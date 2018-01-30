require 'bundler/setup'
Bundler.require(:default, :development)

require 'rails'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:  'firebird',
  username: 'SYSDBA',
  password: 'masterkey',
  database: '/var/lib/firebird/2.5/data/example.fdb'
)

class SisTest < ActiveRecord::Base
  self.table_name = 'sis_test'
  self.primary_key = 'id_test'
end

RSpec.configure do |config|
  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
