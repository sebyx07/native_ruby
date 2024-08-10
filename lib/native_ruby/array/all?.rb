# frozen_string_literal: true

class Array
  # Checks if all elements of the array satisfy a given condition.
  #
  # When called with a block, it returns true if the block returns a truthy value
  # for all elements in the array. When called without a block, it returns true if
  # all elements in the array are truthy (i.e., not false or nil).
  #
  # @yield [element] The block to test each element against
  # @yieldparam element [Object] Each element of the array
  # @yieldreturn [Boolean] Whether the element satisfies the condition
  #
  # @return [Boolean] true if all elements satisfy the condition (or are truthy), false otherwise
  #
  # @example With a block
  #   [1, 2, 3].all? { |element| element > 0 } #=> true
  #   [1, 2, 3].all? { |element| element.even? } #=> false
  #
  # @example Without a block
  #   [1, 2, 3].all? #=> true
  #   [1, false, 3].all? #=> false
  #
  # @note This method stops iterating on the first element that doesn't satisfy the condition
  def all?
    each do |element|
      if block_given?
        return false unless yield(element)
      else
        return false unless element
      end
    end
    true
  end
end
