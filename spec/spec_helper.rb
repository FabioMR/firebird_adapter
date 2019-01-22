require 'bundler/setup'
Bundler.require(:default, :development)

require 'rails'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:  'firebird',
  username: 'SYSDBA',
  password: 'masterkey',
  host: 'db',
  database: '/firebird/data/example.fdb',
  encoding: 'UTF-8',
)

class SisTest < ActiveRecord::Base
  self.table_name = 'sis_test'
  self.primary_key = 'id_test'
end