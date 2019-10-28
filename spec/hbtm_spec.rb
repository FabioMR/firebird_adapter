require 'spec_helper'

describe 'migration' do

  class Record1 < ActiveRecord::Base
    has_and_belongs_to_many :record2s
  end

  class Record2 < ActiveRecord::Base
    has_and_belongs_to_many :record1s
  end

  def drop_tables
    ActiveRecord::Migration.class_eval do
      drop_table :record1s
      drop_table :record2s
      drop_table :record1s_record2s
    rescue
    end
  end

  before(:each) do
    ActiveRecord::Migration.verbose = false

    drop_tables

    ActiveRecord::Migration.class_eval do
      create_table :record1s do |t|
      end

      create_table :record2s do |t|
      end

      create_table :record1s_record2s, id: false do |t|
        t.integer :record1_id, null: false
        t.integer :record2_id, null: false
      end
    end

    Record1.reset_column_information
    Record2.reset_column_information
  end

  after(:each) do
    drop_tables
    ActiveRecord::Migration.verbose = true
  end

  it 'create and destroy with HBTM' do
    Record2.create!(id: 2, record1s: [Record1.create!(id: 1)])
    expect(Record1.first.id).to be 1
    expect(Record2.first.id).to be 2
    expect(Record2.first.record1s.first.id).to be 1

    Record1.destroy_all
    expect(Record1.count).to be 0

    Record2.destroy_all
    expect(Record2.count).to be 0
  end

end
