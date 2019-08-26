# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module Firebird
      module Quoting

        def unquoted_true
          boolean_domain[:true]
        end

        def quoted_true # :nodoc:
          quote unquoted_true
        end

        def unquoted_false
          boolean_domain[:false]
        end

        def quoted_false # :nodoc:
          quote unquoted_false
        end

        def lookup_cast_type_from_column(column) # :nodoc:
          sql_type = (column.domain == boolean_domain[:name]) ? 'BOOLEAN' : column.sql_type
          type_map.lookup(sql_type)
        end
      
        def quoted_date(value)
          super.sub(/(\.\d{6})\z/, $1.to_s.first(5))
        end
      end
    end
  end
end
