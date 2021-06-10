# FirebirdAdapter

ActiveRecord Firebird Adapter for Rails 5 and 6.

According to our new versioning strategy use:
- firebird_adapter 6.x for Rails 6.x  
- firebird_adapter 5.x for Rails from 5.x

## Installation

Add in your Gemfile:

```ruby
gem 'firebird_adapter', '6.0'
```


And then execute:

    $ bundle

## Usage

Configure your database.yml:

```ruby
development:
  adapter: firebird
  host: localhost
  database: db/development.fdb
  username: SYSDBA
  password: masterkey
  encoding: UTF-8
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
