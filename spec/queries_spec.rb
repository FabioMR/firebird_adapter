require 'spec_helper'

describe 'query' do

  it '#first' do
    expect(SisTest.first).to be_nil

    SisTest.create!
    expect(SisTest.first).to be_present
  end

  it '#second' do
    expect(SisTest.first).to be_nil

    SisTest.create!(field_integer: 1)
    SisTest.create!(field_integer: 2)
    expect(SisTest.second).to be_present
    expect(SisTest.second.field_integer).to be 2
  end

  it '#third' do
    expect(SisTest.first).to be_nil

    SisTest.create!(field_integer: 1)
    SisTest.create!(field_integer: 2)
    SisTest.create!(field_integer: 3)
    expect(SisTest.third).to be_present
    expect(SisTest.third.field_integer).to be 3
  end

  it '#fourth' do
    expect(SisTest.first).to be_nil

    SisTest.create!(field_integer: 1)
    SisTest.create!(field_integer: 2)
    SisTest.create!(field_integer: 3)
    SisTest.create!(field_integer: 4)
    expect(SisTest.fourth).to be_present
    expect(SisTest.fourth.field_integer).to be 4
  end

  it '#fifth' do
    expect(SisTest.first).to be_nil

    SisTest.create!(field_integer: 1)
    SisTest.create!(field_integer: 2)
    SisTest.create!(field_integer: 3)
    SisTest.create!(field_integer: 4)
    SisTest.create!(field_integer: 5)
    expect(SisTest.fifth).to be_present
    expect(SisTest.fifth.field_integer).to be 5
  end

  it '#all' do
    expect(SisTest.all).to be_empty

    SisTest.create!
    expect(SisTest.all).to be_any
  end

  it '#limit' do
    SisTest.create!
    SisTest.create!
    expect(SisTest.limit(1).count).to eq 1
    expect(SisTest.limit(3).count).to eq 2
  end

  it '#limit, #offset' do
    SisTest.create!
    SisTest.create!
    expect(SisTest.limit(2).offset(2).to_a.first).to eq SisTest.last
  end

  it '#where' do
    SisTest.create!
    expect(SisTest.where('id_test < ?', 0).count).to eq 0
    expect(SisTest.where('id_test > ?', 0).count).to eq 1
  end

end
