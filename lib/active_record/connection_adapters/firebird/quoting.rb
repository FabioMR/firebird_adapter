module ActiveRecord::ConnectionAdapters::Firebird::Quoting
  def quoted_date(value)
    super.sub(/(\.\d{6})\z/, $1.to_s.first(5))
  end
end
