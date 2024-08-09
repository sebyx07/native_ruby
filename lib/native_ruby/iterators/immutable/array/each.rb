# frozen_string_literal: true

# Array immutable each method
class Array
  # Iterates the given block for each element with index.
  #
  # This implementation is considered immutable because it does not modify
  # the array's size or structure during iteration. The array's length is
  # calculated once at the beginning and remains constant throughout the iteration.
  #
  # If no block is given, returns an Enumerator object.
  #
  # @yield [Object] Passes each element of the array to the block.
  # @return [Array] Returns self.
  # @return [Enumerator] If no block is given.
  def each
    return to_enum(:each) { self.length } unless block_given?

    i = 0
    length = self.length
    while i < length
      yield self[i]
      i = i.succ
    end

    self
  end
end
