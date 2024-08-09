# frozen_string_literal: true

# Array
class Array
  # Iterates the given block for each element with index.
  #
  # This implementation is considered mutable because:
  # 1. It recalculates self.length on each iteration, allowing for potential
  #    changes to the array's size during iteration.
  # 2. If the array is modified during iteration (e.g., by the yielded block),
  #    the method will operate on the modified array.
  #
  # If no block is given, returns an Enumerator object.
  #
  # @yield [Object] Passes each element of the array to the block.
  # @return [Array] Returns self.
  # @return [Enumerator] If no block is given.
  def each
    return to_enum(:each) { self.length } unless block_given?

    i = 0
    while i < self.length  # Note: self.length is evaluated on each iteration
      yield self[i]
      i = i.succ
    end
    self
  end
end
