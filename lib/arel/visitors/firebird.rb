class Arel::Visitors::Firebird < Arel::Visitors::ToSql

  private

  def visit_Arel_Nodes_SelectCore(o, collector, select_statement)
    collector << 'SELECT'

    visit_Arel_Nodes_SelectOptions(select_statement, collector)

    collector = maybe_visit o.top, collector

    collector = maybe_visit o.set_quantifier, collector

    collect_nodes_for o.projections, collector, SPACE

    if o.source && !o.source.empty?
      collector << ' FROM '
      collector = visit o.source, collector
    end

    collect_nodes_for o.wheres, collector, WHERE, AND
    collect_nodes_for o.groups, collector, GROUP_BY
    unless o.havings.empty?
      collector << ' HAVING '
      inject_join o.havings, collector, AND
    end
    collect_nodes_for o.windows, collector, WINDOW

    collector
  end

  def visit_Arel_Nodes_SelectStatement o, collector
    if o.with
      collector = visit o.with, collector
      collector << SPACE
    end

    collector = o.cores.inject(collector) { |c,x|
      visit_Arel_Nodes_SelectCore(x, c, o)
    }

    unless o.orders.empty?
      collector << ORDER_BY
      len = o.orders.length - 1
      o.orders.each_with_index { |x, i|
        collector = visit(x, collector)
        collector << COMMA unless len == i
      }
    end

    collector
  end

  def visit_Arel_Nodes_Limit(o, collector)
    collector << 'FIRST '
    visit o.expr, collector
  end

  def visit_Arel_Nodes_Offset(o, collector)
    collector << 'SKIP '
    visit o.expr, collector
  end

  def visit_Arel_Nodes_Union o, collector
    infix_value(o, collector, ' UNION ')
  end

  def visit_Arel_Nodes_UnionAll o, collector
    infix_value(o, collector, ' UNION ALL ')
  end
end
