ActiveRecord::Calculations.module_eval do
  def count(column_name = nil)
    return super() if block_given?
    calculate(:count, column_name || 1)
  end
end

ActiveRecord::FinderMethods.module_eval do
  def second
    order(primary_key).limit(2).offset(2).to_a.first
  end

  def third
    order(primary_key).limit(3).offset(3).to_a.first
  end

  def fourth
    order(primary_key).limit(4).offset(4).to_a.first
  end

  def fifth
    order(primary_key).limit(5).offset(5).to_a.first
  end
end
