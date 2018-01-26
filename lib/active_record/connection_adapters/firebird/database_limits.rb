module ActiveRecord::ConnectionAdapters::Firebird
  module DatabaseLimits

    def table_alias_length
      31
    end

    def column_name_length
      31
    end

    def table_name_length
      31
    end

    def index_name_length
      31
    end

    def indexes_per_table
      65_535
    end

    def in_clause_length
      1_499
    end

    def sql_query_length
      32_767
    end

  end
end
