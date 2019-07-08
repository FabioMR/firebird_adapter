require 'fb'

require 'active_record/connection_adapters/firebird/connection'
require 'active_record/connection_adapters/firebird/database_limits'
require 'active_record/connection_adapters/firebird/database_statements'
require 'active_record/connection_adapters/firebird/schema_statements'

require 'arel/visitors/firebird'

class ActiveRecord::ConnectionAdapters::FirebirdAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter

  ADAPTER_NAME = "Firebird".freeze
  DEFAULT_ENCODING = "Windows-1252".freeze

  include ActiveRecord::ConnectionAdapters::Firebird::DatabaseLimits
  include ActiveRecord::ConnectionAdapters::Firebird::DatabaseStatements
  include ActiveRecord::ConnectionAdapters::Firebird::SchemaStatements

  def arel_visitor
    @arel_visitor ||= Arel::Visitors::Firebird.new(self)
  end

  def prefetch_primary_key?(table_name = nil)
    true
  end

  def active?
    return false unless @connection.open?

    @connection.query("SELECT 1 FROM RDB$DATABASE")
    true
  rescue
    false
  end

  def reconnect!
    disconnect!
    @connection = ::Fb::Database.connect(@config)
  end

  def disconnect!
    super
    @connection.close rescue nil
  end

  def reset!
    reconnect!
  end

  def primary_keys(table_name)
    raise ArgumentError unless table_name.present?

    names = query_values(<<~SQL, "SCHEMA")
      SELECT
        s.rdb$field_name
      FROM
        rdb$indices i
        JOIN rdb$index_segments s ON i.rdb$index_name = s.rdb$index_name
        LEFT JOIN rdb$relation_constraints c ON i.rdb$index_name = c.rdb$index_name
      WHERE
        i.rdb$relation_name = '#{table_name.upcase}'
        AND c.rdb$constraint_type = 'PRIMARY KEY';
    SQL

    names.map(&:strip).map(&:downcase)
  end

  def encoding
    @connection.encoding
  end

  def log(sql, name = "SQL", binds = [], type_casted_binds = [], statement_name = nil) # :doc:
    sql = sql.encode('UTF-8', encoding) if sql.encoding.to_s == encoding
    super
  end

protected

  def translate_exception(e, message)
    case e.message
    when /violation of FOREIGN KEY constraint/
      ActiveRecord::InvalidForeignKey.new(message)
    when /violation of PRIMARY or UNIQUE KEY constraint/, /attempt to store duplicate value/
      ActiveRecord::RecordNotUnique.new(message)
    when /This operation is not defined for system tables/
      ActiveRecord::ActiveRecordError.new(message)
    else
      super
    end
  end

end
