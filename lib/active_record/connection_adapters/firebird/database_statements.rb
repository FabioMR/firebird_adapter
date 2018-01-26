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
        cursor = @connection.execute(sql, *type_casted_binds)
        ActiveRecord::Result.new(cursor.fields.map(&:name), cursor.fetchall) if cursor
      end
    end
  end

  def next_sequence_value(sequence_name)
    @connection.query('SELECT NEXT VALUE FOR #{sequence_name} FROM RDB$DATABASE')[0][0]
  end

end
