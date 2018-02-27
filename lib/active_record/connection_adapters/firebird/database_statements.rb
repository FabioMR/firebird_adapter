module ActiveRecord::ConnectionAdapters::Firebird::DatabaseStatements

  def execute(sql, name = nil)
    log(sql, name) do
      ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
        @connection.query(sql)
      end
    end
  end

  def exec_query(sql, name = 'SQL', binds = [], prepare: false)
    type_casted_binds = type_casted_binds(binds)

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

  def default_sequence_name(table_name, _column = nil)
    "#{table_name}_g01"
  end

  def next_sequence_value(sequence_name)
    @connection.query("SELECT NEXT VALUE FOR #{sequence_name} FROM RDB$DATABASE")[0][0]
  end

end
