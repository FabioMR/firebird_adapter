require 'spec_helper'

describe 'field types' do

  around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  it 'varchar' do
    value = 'A1áéíóúàçã9z'
    record = SisTest.create!(field_varchar: value).reload
    expect(record.field_varchar).to eq value
  end

  it 'char' do
    value = 'A1áçã9'
    record = SisTest.create!(field_char: value).reload
    expect(record.field_char).not_to eq value
    expect(record.field_char.strip).to eq value
  end

  it 'date' do
    time = Time.current

    record = SisTest.create!(field_date: time).reload
    expect(record.field_date).not_to eq time
    expect(record.field_date).to eq time.change(usec: 0)

    record = SisTest.create!(field_date: time.to_date).reload
    expect(record.field_date).to eq time.to_date
  end

  it 'smallint' do
    record = SisTest.create!(field_smallint: '1').reload
    expect(record.field_smallint).to eq 1
  end

  it 'integer' do
    record = SisTest.create!(field_integer: '1').reload
    expect(record.field_integer).to eq 1
  end

  it 'double precision' do
    record = SisTest.create!(field_double_precision: '99.99').reload
    expect(record.field_double_precision).to eq 99.99
  end

  it 'blob text' do
    value = <<-EOF
    AAAAAAAAAAAA
    111111111111
    A1áéíóúàçã9z
    EOF
    record = SisTest.create!(field_blob_text: value).reload
    expect(record.field_blob_text).to eq value
  end

  it 'blob binary' do
    value = 'binary value'
    record = SisTest.create!(field_blob_binary: value).reload
    expect(record.field_blob_binary).to eq value
  end

end
