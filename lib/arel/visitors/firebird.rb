module Arel
  class SelectManager
    attr_reader :parentheses_ignored

    def ignore_parentheses
      @parentheses_ignored = true
      self
    end
  end

  class Visitors::Firebird < Arel::Visitors::ToSql
    private

    def visit_Arel_Nodes_SelectCore(o, collector, select_statement)
      collector << 'SELECT'

      visit_Arel_Nodes_SelectOptions(select_statement, collector)

      collector = collect_optimizer_hints(o, collector)
      collector = maybe_visit o.set_quantifier, collector

      collect_nodes_for o.projections, collector, ' '

      if o.source && !o.source.empty?
        collector << ' FROM '
        collector = visit o.source, collector
      end

      collect_nodes_for o.wheres, collector, ' WHERE ', ' AND '
      collect_nodes_for o.groups, collector, ' GROUP BY '
      unless o.havings.empty?
        collector << ' HAVING '
        inject_join o.havings, collector, ' AND '
      end
      collect_nodes_for o.windows, collector, ' WINDOW '

      collector
    end

    def visit_Arel_Nodes_SelectStatement o, collector
      if o.with
        collector = visit o.with, collector
        collector << ' '
      end

      collector = o.cores.inject(collector) { |c,x|
        visit_Arel_Nodes_SelectCore(x, c, o)
      }

      unless o.orders.empty?
        collector << ' ORDER BY '
        len = o.orders.length - 1
        o.orders.each_with_index { |x, i|
          collector = visit(x, collector)
          collector << ', ' unless len == i
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

    def visit_Arel_SelectManager o, collector
      return visit(o.ast, collector) if o.parentheses_ignored

      collector << '('
      visit(o.ast, collector) << ')'
    end

    def visit_Arel_Nodes_Union o, collector
      infix_value(o, collector, ' UNION ')
    end

    def visit_Arel_Nodes_UnionAll o, collector
      infix_value(o, collector, ' UNION ALL ')
    end
  end
end
