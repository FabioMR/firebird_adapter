module ActiveRecord::ConnectionAdapters::Firebird::DatabaseStatements

  delegate :boolean_domain, to: 'ActiveRecord::ConnectionAdapters::FirebirdAdapter'

  def execute(sql, name = nil)
    sql = sql.encode(encoding, 'UTF-8')

    log(sql, name) do
      ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
        @connection.query(sql)
      end
    end
  end

  def exec_query(sql, name = 'SQL', binds = [], prepare: false)
    sql = sql.encode(encoding, 'UTF-8')

    type_casted_binds = type_casted_binds(binds).map do |value|
      value.encode(encoding) rescue value
    end

    log(sql, name, binds, type_casted_binds) do
      ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
        result = @connection.execute(sql, *type_casted_binds)
        if result.is_a?(Fb::Cursor)
          fields = result.fields.map(&:name)
          rows = result.fetchall.map do |row|
            row.map do |col|
              col.encode('UTF-8', @connection.encoding) rescue col
            end
          end

          result.close
          ActiveRecord::Result.new(fields, rows)
        else
          result
        end
      rescue Exception => e
        raise e.message.encode('UTF-8', @connection.encoding)
      end
    end
  end

  def begin_db_transaction
    log("begin transaction", nil) { @connection.transaction('READ COMMITTED') }
  end

  def commit_db_transaction
    log("commit transaction", nil) { @connection.commit }
  end

  def exec_rollback_db_transaction
    log("rollback transaction", nil) { @connection.rollback }
  end

  def create_table(table_name, **options)
    super

    if options[:sequence] != false && options[:id] != false
      sequence_name = options[:sequence] || default_sequence_name(table_name)
      create_sequence(sequence_name)
    end
  end

  def drop_table(table_name, options = {})
    if options[:sequence] != false
      sequence_name = options[:sequence] || default_sequence_name(table_name)
      drop_sequence(sequence_name) if sequence_exists?(sequence_name)
    end

    super
  end

  def create_sequence(sequence_name)
    execute("CREATE SEQUENCE #{sequence_name}") rescue nil
  end

  def drop_sequence(sequence_name)
    execute("DROP SEQUENCE #{sequence_name}") rescue nil
  end

  def sequence_exists?(sequence_name)
    @connection.generator_names.include?(sequence_name)
  end

  def default_sequence_name(table_name, _column = nil)
    "#{table_name}_g01"
  end

  def next_sequence_value(sequence_name)
    @connection.query("SELECT NEXT VALUE FOR #{sequence_name} FROM RDB$DATABASE")[0][0]
  end

end
