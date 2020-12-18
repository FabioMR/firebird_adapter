require 'spec_helper'

describe 'populate' do

  around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  it '.create' do
    record = SisTest.create!
    expect(record).to be_persisted
    expect(record.id_test).to be_present

    expect do
      record = SisTest.create!(field_char: '012345678912345X')
    end.to raise_error(ActiveRecord::StatementInvalid, /RangeError/) 
  end

  it '.update_all' do
    SisTest.create!
    SisTest.update_all(field_varchar: 'ALTERADO')
    expect(SisTest.first.field_varchar).to eq 'ALTERADO'
  end

  it '.destroy_all' do
    SisTest.create!
    SisTest.destroy_all
    expect(SisTest.all).to be_empty
  end

  it '#update' do
    record = SisTest.create!
    record.update!(field_varchar: 'ALTERADO')
    expect(record.field_varchar).to eq 'ALTERADO'
    
    expect do
      record.update!(field_char: '012345678912345X')
    end.to raise_error(ActiveRecord::StatementInvalid, /RangeError/) 
  end

  it '#destroy' do
    record = SisTest.create!.destroy!
    expect(record).not_to be_persisted
  end

end
