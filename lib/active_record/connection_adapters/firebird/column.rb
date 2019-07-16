module ActiveRecord
  module ConnectionAdapters
    module Firebird
      class Column < ActiveRecord::ConnectionAdapters::Column # :nodoc:
        class << self
          attr_reader :sub_type, :domain

          def initialize(name, default, sql_type_metadata = nil, null = true, fb_options = {})
            @domain, @sub_type = fb_options.values_at(:domain, :sub_type)
            super(name.downcase, parse_default(default), sql_type_metadata, null)
          end

          private
          def parse_default(default)
            return if default.nil? || default =~ /null/i
            default.gsub(/^\s*DEFAULT\s+/i, '').gsub(/(^'|'$)/, '')
          end
        end
      end
    end
  end
end
