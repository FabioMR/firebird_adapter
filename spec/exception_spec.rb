require 'spec_helper'

describe 'exception' do

  before(:all) do
    @initial_encoding ||= ActiveRecord::Base.connection_config[:encoding] || ActiveRecord::ConnectionAdapters::FirebirdAdapter::DEFAULT_ENCODING
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.connection_config.merge(encoding: 'Windows-1252'))
  end

  after(:all) do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.connection_config.merge(encoding: @initial_encoding))
  end

  it 'execute block with exception' do
    expect do
      ActiveRecord::Base.connection.exec_query <<-SQL
        EXECUTE BLOCK
        AS
        BEGIN
          EXCEPTION ERROR('A1áéíóúàçã9z');
        END
      SQL
    end.to raise_error(Exception, /A1áéíóúàçã9z/)
  end

end
