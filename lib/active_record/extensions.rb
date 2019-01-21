ActiveRecord::Calculations.module_eval do
  def count(column_name = nil)
    return super() if block_given?
    calculate(:count, column_name || 1)
  end
end