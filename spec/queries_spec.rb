require 'spec_helper'

describe 'query' do

  around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  it '#first' do
    SisTest.create!(id_test: 1)
    expect(SisTest.first.id_test).to be 1
  end

  it '#second' do
    SisTest.create!(id_test: 1)
    SisTest.create!(id_test: 2)
    expect(SisTest.second.id_test).to be 2
  end

  it '#third' do
    SisTest.create!(field_integer: 1)
    SisTest.create!(field_integer: 2)
    SisTest.create!(field_integer: 3)
    expect(SisTest.third.field_integer).to be 3
  end

  it '#fourth' do
    SisTest.create!(id_test: 1)
    SisTest.create!(id_test: 2)
    SisTest.create!(id_test: 3)
    SisTest.create!(id_test: 4)
    expect(SisTest.fourth.id_test).to be 4
  end

  it '#fifth' do
    SisTest.create!(id_test: 1)
    SisTest.create!(id_test: 2)
    SisTest.create!(id_test: 3)
    SisTest.create!(id_test: 4)
    SisTest.create!(id_test: 5)
    expect(SisTest.fifth.id_test).to be 5
  end

  it '#all' do
    expect(SisTest.all).to be_empty

    SisTest.create!
    expect(SisTest.all).to be_any
  end

  it '#limit' do
    SisTest.create!(id_test: 1)
    SisTest.create!(id_test: 21)
    expect(SisTest.limit(3).first.id).to eq 1
    expect(SisTest.limit(1).count).to eq 1
    expect(SisTest.limit(3).count).to eq 2
  end

  it '#offset' do
    SisTest.create!(id_test: 1)
    SisTest.create!(id_test: 2)
    expect(SisTest.offset(1).first.id).to eq 2
    expect(SisTest.offset(2).first).to be_nil
  end

  it '#limit, #offset' do
    SisTest.create!(id_test: 1)
    SisTest.create!(id_test: 2)
    SisTest.create!(id_test: 3)
    expect(SisTest.limit(2).offset(1).count).to eq 2
    expect(SisTest.limit(1).offset(1).to_a.first.id).to eq 2
    expect(SisTest.limit(1).offset(2).to_a.first.id).to eq 3
  end

  it '#where' do
    SisTest.create!
    expect(SisTest.where('id_test < ?', 0).count).to eq 0
    expect(SisTest.where('id_test > ?', 0).count).to eq 1
  end

  it 'where with accent' do
    value = 'A1áéíóúàçã9z'
    SisTest.create!(field_varchar: value)

    expect(SisTest.where(SisTest.arel_table[:field_varchar].eq(value)).count).to eq 1
    expect(SisTest.where(field_varchar: value).count).to eq 1
  end

end
