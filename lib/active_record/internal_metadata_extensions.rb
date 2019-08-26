class ActiveRecord::InternalMetadata
  class << self
    def adapter_name
      connection.adapter_name.downcase.to_sym
    end

    def value_name
      adapter_name == :firebird ? :value_ : :value
    end

    def []=(key, value)
      find_or_initialize_by(key: key).update!(value_name => value)
    end

    def [](key)
      where(key: key).pluck(value_name).first
    end

    def create_table
      unless table_exists?
        key_options = connection.internal_string_options_for_primary_key

        connection.create_table(table_name, id: false) do |t|
          t.string :key, key_options
          t.string value_name
          t.timestamps
        end
      end
    end
  end
end
