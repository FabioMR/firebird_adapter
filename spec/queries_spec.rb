require 'spec_helper'

describe 'query' do

  it '#first' do
    expect(SisTest.first).to be_nil

    SisTest.create!
    expect(SisTest.first).to be_present
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
