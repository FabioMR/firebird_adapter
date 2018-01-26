require 'spec_helper'

describe 'firebird_adapter' do

  it 'returns first record' do
    expect(SisTest.first).to be_nil
  end

end
