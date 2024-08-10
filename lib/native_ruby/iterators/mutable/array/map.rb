# frozen_string_literal: true

class Array
  # Creates a new array containing the values returned by the block.
  #
  # This implementation is considered mutable because:
  # 1. It recalculates self.length on each iteration, allowing for potential
  #    changes to the array's size during iteration.
  # 2. If the original array is modified during iteration (e.g., by the yielded block),
  #    the method will operate on the modified array.
  #
  # Note that while the original array can be mutated during iteration,
  # the method still returns a new array with the mapped values.
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
    while i < self.length  # Note: self.length is evaluated on each iteration
      result << yield(self[i])
      i = i.succ
    end
    result
  end

  alias_method :collect, :map
end
