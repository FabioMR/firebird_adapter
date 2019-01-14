require 'fb'

require 'active_record/connection_adapters/firebird/connection'
require 'active_record/connection_adapters/firebird/calculations'
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
