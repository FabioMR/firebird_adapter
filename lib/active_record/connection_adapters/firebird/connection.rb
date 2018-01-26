module ActiveRecord::ConnectionHandling
  def firebird_connection(config)
    config = config.symbolize_keys.dup.reverse_merge(downcase_names: true, port: 3050)

    if config[:host]
      config[:database] = "#{config[:host]}/#{config[:port]}:#{config[:database]}"
    else
      config[:database] = File.expand_path(config[:database], Rails.root)
    end

    connection = ::Fb::Database.new(config).connect

    ActiveRecord::ConnectionAdapters::FirebirdAdapter.new(connection, logger, config)
  end
end
