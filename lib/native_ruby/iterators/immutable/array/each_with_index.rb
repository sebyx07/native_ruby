# frozen_string_literal: true

class Array
  # Iterates the given block for each element with its index.
  #
  # This implementation is considered immutable because it does not modify
  # the array's size or structure during iteration. The array's length is
  # calculated once at the beginning and remains constant throughout the iteration.
  #
  # If no block is given, returns an Enumerator object.
  #
  # @yield [Object, Integer] Passes each element of the array and its index to the block.
  # @yieldparam element [Object] The current element in the iteration.
  # @yieldparam index [Integer] The index of the current element.
  # @return [Array] Returns self.
  # @return [Enumerator] If no block is given.
  def each_with_index
    return to_enum(:each_with_index) { self.length } unless block_given?

    i = 0
    length = self.length
    while i < length
      yield self[i], i
      i = i.succ
    end

    self
  end
end
