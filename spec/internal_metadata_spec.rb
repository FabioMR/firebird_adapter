require 'spec_helper'

describe 'internal Mmetadata' do

  before(:all) do
    ActiveRecord::Base.connection
  end

  after(:all) do
    ActiveRecord::Base.connection('DROP TABLE ar_internal_metadata') rescue nil
  end

  it '#create_table' do
    expect { ActiveRecord::InternalMetadata.create_table }.not_to raise_error
  end

end
