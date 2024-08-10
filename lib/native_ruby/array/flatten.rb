# frozen_string_literal: true

class Array
  # Flattens the array to the specified level.
  #
  # If no level is provided, flattens recursively.
  #
  # @param level [Integer, nil] The level of flattening. If nil, flatten recursively.
  # @return [Array] A new array with the flattened elements.
  #
  # @example
  #   [1, [2, 3, [4, 5]]].flatten      #=> [1, 2, 3, 4, 5]
  #   [1, [2, 3, [4, 5]]].flatten(1)   #=> [1, 2, 3, [4, 5]]
  def flatten(level = nil)
    return self.dup if level == 0

    result = []
    each do |element|
      if element.is_a?(Array) && (level.nil? || level > 0)
        result.concat(level.nil? ? element.flatten : element.flatten(level - 1))
      else
        result << element
      end
    end
    result
  end
end
