class Arel::Visitors::Firebird  < Arel::Visitors::ToSql

private

  def visit_Arel_Nodes_Limit o, collector
    collector << " ROWS "
    visit o.expr, collector
  end

  def visit_Arel_Nodes_Offset o, collector
    collector << " SKIP "
    visit o.expr, collector
    collector << SPACE
  end

  def limit_with_rows o, collector
    collector << " ROWS "
    visit o.offset.expr + 1, collector
    collector << " TO "
    visit o.offset.expr + o.limit.expr, collector
  end

end
