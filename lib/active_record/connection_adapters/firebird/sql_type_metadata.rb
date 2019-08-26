module ActiveRecord
  module ConnectionAdapters
    module Firebird
      class SqlTypeMetadata < ActiveRecord::ConnectionAdapters::SqlTypeMetadata

        def initialize(sql_type: nil, type: nil, limit: nil, precision: nil, scale: nil, **firebird_options)
          @sql_type = sql_type
          @type = (firebird_options[:field].domain) ? :boolean : sql_type
          @limit = limit
          @precision = precision
          @scale = scale
          @firebird_options = firebird_options
        end

        protected

        def attributes_for_hash
          super + [@firebird_options]
        end

      end
    end
  end
end
