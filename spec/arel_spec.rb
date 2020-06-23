require 'spec_helper'

describe 'arel' do

  it 'union' do
    table = Arel::Table.new(:table)

    expect(Arel::Nodes::Union.new(table.project(:id), table.project(:id)).to_sql).to eq '(SELECT id FROM table) UNION (SELECT id FROM table)'
    expect(Arel::Nodes::Union.new(table.project(:id), table.project(:id).ignore_parentheses).to_sql).to eq '(SELECT id FROM table) UNION SELECT id FROM table'
  end

  it 'union all' do
    table = Arel::Table.new(:table)

    expect(Arel::Nodes::UnionAll.new(table.project(:id), table.project(:id)).to_sql).to eq '(SELECT id FROM table) UNION ALL (SELECT id FROM table)'
    expect(Arel::Nodes::UnionAll.new(table.project(:id), table.project(:id).ignore_parentheses).to_sql).to eq '(SELECT id FROM table) UNION ALL SELECT id FROM table'
  end

end
