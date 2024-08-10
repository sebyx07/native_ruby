# frozen_string_literal: true

class Array
  # Creates a new array containing the values returned by the block.
  #
  # This implementation is considered immutable for two reasons:
  # 1. It does not modify the original array's size or structure.
  # 2. It creates and returns a new array with the mapped values.
  #
  # The original array's length is calculated once at the beginning
  # and remains constant throughout the iteration.
  #
  # If no block is given, returns an Enumerator object.
  #
  # @yield [Object] Passes each element of the array to the block.
  # @return [Array] A new array with the results of running the block once for every element.
  # @return [Enumerator] If no block is given.
  def map
    return to_enum(:map) { self.length } unless block_given?

    i = 0
    result = []
    length = self.length
    while i < length
      result << yield(self[i])
      i = i.succ
    end
    result
  end

  alias_method :collect, :map
end
