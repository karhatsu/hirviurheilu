module ModelValueComparator
  def values_equal?
    return true if old_values.nil?
    old_values.each do |parameter, old_value|
      next if new_value_equals_current?(parameter)
      return false if old_value_differs_from_current?(parameter, old_value)
    end
    true
  end
  
  private
  def new_value_equals_current?(parameter)
    current_value_in_database(parameter).to_s == new_value(parameter).to_s
  end
  
  def old_value_differs_from_current?(parameter, old_value)
    current_value_in_database(parameter).to_s != old_value.to_s
  end
  
  def new_value(parameter)
    send(parameter.to_s)
  end
  
  def current_value_in_database(parameter)
    send(parameter.to_s + '_was')
  end
end