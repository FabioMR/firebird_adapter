require 'spec_helper'

describe 'migration' do

  class Record < ActiveRecord::Base
  end

  def create_table(&block)
    ActiveRecord::Migration.class_eval do
      create_table :records do |t|
        block.call(t)
      end
    end
  end

  before(:each) do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Migration.class_eval { drop_table :records rescue nil }
    Record.reset_column_information
  end

  after(:each) do
    ActiveRecord::Migration.class_eval { drop_table :records rescue nil }
    ActiveRecord::Migration.verbose = true
  end

  it 'primary key' do
    create_table do |t|
    end

    record = Record.create!(id: 1)
    expect(record.reload.id).to be 1
  end

  it 'string' do
    create_table do |t|
      t.string :field_string
    end

    record = Record.create!(field_string: 'STRING')
    expect(record.reload.field_string).to eq 'STRING'
  end

  it 'text' do
    create_table do |t|
      t.text :field_text
    end

    record = Record.create!(field_text: 'TEXT')
    expect(record.reload.field_text).to eq 'TEXT'
  end

  it 'integer' do
    create_table do |t|
      t.integer :field_integer
    end

    record = Record.create!(field_integer: 99)
    expect(record.reload.field_integer).to eq 99
  end

  it 'float' do
    create_table do |t|
      t.float :field_float
    end

    record = Record.create!(field_float: 9.9)
    expect(record.reload.field_float.round(1)).to eq 9.9
  end

  it 'decimal' do
    create_table do |t|
      t.decimal :field_decimal, precision: 10, scale: 2
    end

    record = Record.create!(field_decimal: 9.9)
    expect(record.reload.field_decimal).to eq 9.9
  end

  it 'datetime' do
    create_table do |t|
      t.datetime :field_datetime
    end

    record = Record.create!(field_datetime: DateTime.new(2018, 1, 1, 10))
    expect(record.reload.field_datetime).to eq DateTime.new(2018, 1, 1, 10)
  end

  it 'timestamp' do
    create_table do |t|
      t.timestamp :field_timestamp
    end

    record = Record.create!(field_timestamp: DateTime.new(2018, 1, 1, 10))
    expect(record.reload.field_timestamp).to eq DateTime.new(2018, 1, 1, 10)
  end

  it 'date' do
    create_table do |t|
      t.date :field_date
    end

    record = Record.create!(field_date: DateTime.new(2018, 1, 1, 10))
    expect(record.reload.field_date).to eq DateTime.new(2018, 1, 1, 10)
  end

  it 'binary' do
    create_table do |t|
      t.binary :field_binary
    end

    record = Record.create!(field_binary: 'BINARY')
    expect(record.reload.field_binary).to eq 'BINARY'
  end

  it 'boolean' do
    create_table do |t|
      t.boolean :field_boolean
    end

    record = Record.create!(field_boolean: false)
    expect(record.reload.field_boolean).to eq 0

    record = Record.create!(id: 2, field_boolean: true)
    expect(record.reload.field_boolean).to eq 1
  end
  
  it 'indexes' do
    expect { ActiveRecord::Migration.add_index :sis_test, :id_test, name: 'ix_id_test' }.not_to raise_error
    expect { ActiveRecord::Migration.remove_index :sis_test, :id_test, { name: 'ix_id_test' } }.not_to raise_error
  end

  it 'foreign keys' do
    expect { ActiveRecord::Migration.add_foreign_key :sis_test, :sis_test, column: :id_test, primary_key: :id_test, name: 'foreign_key_' }.not_to raise_error
    expect { ActiveRecord::Migration.remove_foreign_key :sis_test, name: 'foreign_key_' }.not_to raise_error
  end

  it 'add column' do
    create_table do |t|
    end

    ActiveRecord::Migration.add_column :records, :new_field, :string

    expect(Record.has_attribute?(:new_field)).to be
  end

  it 'remove column' do
    create_table do |t|
      t.string :new_field
    end

    ActiveRecord::Migration.remove_column :records, :new_field

    expect(Record.has_attribute?(:new_field)).not_to be
  end

end
