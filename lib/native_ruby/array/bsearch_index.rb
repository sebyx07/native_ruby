# frozen_string_literal: true

class Array
  # Performs an optimized binary search on the array and returns the index of the found element.
  #
  # This method can operate in two modes: find-minimum mode and find-any mode.
  # The mode is automatically determined by the value returned from the block
  # on the first yield.
  #
  # If no block is given, returns an Enumerator.
  #
  # @yieldparam element [Object] An element from the array
  # @yieldreturn [Boolean, Integer] In find-minimum mode, return true/false.
  #   In find-any mode, return negative integer, 0, or positive integer.
  #
  # @return [Integer, nil, Enumerator] The index of the found element, nil if not found, or an Enumerator if no block given
  #
  # @example Find-minimum mode (condition)
  #   ary = [0, 4, 7, 10, 12]
  #   ary.bsearch_index {|x| x >= 4 } #=> 1
  #   ary.bsearch_index {|x| x >= 6 } #=> 2
  #   ary.bsearch_index {|x| x >= 100 } #=> nil
  #
  # @example Find-any mode (three-way comparison)
  #   ary = [0, 4, 7, 10, 12]
  #   ary.bsearch_index {|x| 1 - x / 4 } #=> 1 or 2
  #   ary.bsearch_index {|x| 4 - x / 2 } #=> nil
  #
  # @example Without a block
  #   ary.bsearch_index #=> returns an Enumerator
  #
  # @note The array must be sorted for this method to behave correctly
  #
  # @raise [TypeError] If the block returns an invalid value in find-any mode
  def bsearch_index
    return to_enum(:bsearch_index) { size } unless block_given?

    return nil if empty?

    low = 0
    high = size - 1
    mid = size / 2

    # Determine the mode based on the first yield result
    finder = yield(self[mid])
    find_minimum_mode = finder || !finder

    if find_minimum_mode
      # Find-minimum mode
      while low < high
        if yield(self[mid])
          high = mid
        else
          low = mid + 1
        end
        mid = low + (high - low) / 2
      end
      yield(self[low]) ? low : nil
    else
      # Find-any mode
      while low <= high
        case yield(self[mid])
        when 0
          return mid
        when 1...Float::INFINITY
          high = mid - 1
        when -Float::INFINITY...0
          low = mid + 1
        else
          raise TypeError, 'wrong argument type (must be numeric, true, or false)'
        end
        mid = low + (high - low) / 2
      end
      nil
    end
  end
end
