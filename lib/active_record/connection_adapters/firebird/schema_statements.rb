module ActiveRecord::ConnectionAdapters::Firebird::SchemaStatements

  def tables(_name = nil)
    @connection.table_names
  end

  def views
    @connection.view_names
  end

private

  def column_definitions(table_name)
    @connection.columns(table_name)
  end

  def new_column_from_field(table_name, field)
    type_metadata = fetch_type_metadata(field["sql_type"])
    ActiveRecord::ConnectionAdapters::Column.new(field["name"], field["default"], type_metadata, field["nullable"], table_name)
  end

end
