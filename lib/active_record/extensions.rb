ActiveRecord::Calculations.module_eval do
  def count(column_name = nil)
    return super() if block_given?
    calculate(:count, column_name || 1)
  end
end

class ActiveRecord::ConnectionAdapters::AbstractAdapter
  def combine_bind_parameters(from_clause: [], join_clause: [], where_clause: [], having_clause: [], limit: nil, offset: nil)
    result = from_clause + join_clause + where_clause + having_clause
    result.unshift(offset) if offset
    result.unshift(limit) if limit
    result  
  end
end if ActiveRecord::VERSION::STRING < '5.2.0'