require 'spec_helper'

describe 'exception' do

  before(:all) do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.connection_config.merge(encoding: 'Windows-1252'))
  end

  after(:all) do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.connection_config.merge(encoding: 'UTF-8'))
  end

  class Model < ActiveRecord::Base
  end

  it 'execute block with exception' do
    expect do
      ActiveRecord::Base.connection.exec_query <<-SQL
        EXECUTE BLOCK
        AS
        BEGIN
          EXCEPTION ERROR('ƒÆ');
        END
      SQL
    end.to raise_error(Exception, /Æ’Ã†/)
  end

end
