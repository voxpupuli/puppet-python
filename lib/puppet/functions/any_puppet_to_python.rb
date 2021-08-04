# frozen_string_literal: true

# @summary
#   Return the Python representation of the passed variable
Puppet::Functions.create_function(:any_puppet_to_python) do
  dispatch :any_puppet_to_python do
    param 'Any', :value
  end

  # @param value
  #   The value to be converted
  #
  # @return [String]
  #   The String representation of value
  def any_puppet_to_python(value)
    case value
    when true then 'True'
    when false then 'False'
    when :undef then 'None'
    when Array then "[#{value.map { |x| any_puppet_to_python(x) }.join(', ')}]"
    when Hash then "{#{value.map { |k, v| "#{any_puppet_to_python(k)}: #{any_puppet_to_python(v)}" }.join(', ')}}"
    else value.inspect
    end
  end
end
