module ActiveRecord::ConnectionAdapters::Firebird::SchemaStatements

  def tables(_name = nil)
    @connection.table_names
  end

  def views
    @connection.view_names
  end

private

  def column_definitions(table_name)
    exec_query(squish_sql(<<-end_sql
      SELECT
        r.rdb$field_name name,
        r.rdb$field_source domain,
        f.rdb$field_type type,
        f.rdb$field_sub_type sub_type,
        f.rdb$field_length limit,
        f.rdb$field_precision field_precision,
        f.rdb$field_scale scale,
        COALESCE(r.rdb$default_source, f.rdb$default_source) default_source,
        COALESCE(r.rdb$null_flag, f.rdb$null_flag) null_flag
      FROM rdb$relation_fields r
      JOIN rdb$fields f ON r.rdb$field_source = f.rdb$field_name
      WHERE r.rdb$relation_name = '#{ar_to_fb_case(table_name)}'
      ORDER BY r.rdb$field_position
    end_sql
    ), 'SCHEMA')
  end

  def new_column_from_field(table_name, field)
    type_metadata = fetch_type_metadata(field["type"])
    ActiveRecord::ConnectionAdapters::Column.new(field["name"], field["default_source"], type_metadata, field["null_flag"].to_i == 0, table_name)
  end

  def ar_to_fb_case(column_name)
    column_name =~ /[[:upper:]]/ ? column_name : column_name.upcase
  end

  def squish_sql(sql)
    sql.strip.gsub(/\s+/, ' ')
  end

end
