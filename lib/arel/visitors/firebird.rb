class Arel::Visitors::Firebird  < Arel::Visitors::ToSql

private

  def visit_Arel_Nodes_Limit o, collector
    collector << "ROWS "
    visit o.expr, collector
  end

  def visit_Arel_Nodes_Offset o, collector
    collector << "TO "
    visit o.expr, collector
  end

end
