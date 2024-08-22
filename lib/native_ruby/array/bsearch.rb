# frozen_string_literal: true

class Array
  # Performs an optimized binary search on the array.
  #
  # This method can operate in two modes: find-minimum mode and find-any mode.
  # The mode is automatically determined by the value returned from the block
  # on the first yield.
  #
  # @yieldparam element [Object] An element from the array
  # @yieldreturn [Boolean, Integer] In find-minimum mode, return true/false.
  #   In find-any mode, return negative integer, 0, or positive integer.
  #
  # @return [Object, nil] The found element, or nil if not found
  #
  # @example Find-minimum mode (condition)
  #   ary = [0, 4, 7, 10, 12]
  #   ary.bsearch {|x| x >= 4 } #=> 4
  #   ary.bsearch {|x| x >= 6 } #=> 7
  #   ary.bsearch {|x| x >= 100 } #=> nil
  #
  # @example Find-any mode (three-way comparison)
  #   ary = [0, 4, 7, 10, 12]
  #   ary.bsearch {|x| 1 - x / 4 } #=> 4 or 7
  #   ary.bsearch {|x| 4 - x / 2 } #=> nil
  #
  # @note The array must be sorted for this method to behave correctly
  #
  # @raise [TypeError] If the block returns an invalid value in find-any mode
  def bsearch
    return to_enum(:bsearch) { size } unless block_given?

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
      yield(self[low]) ? self[low] : nil
    else
      # Find-any mode
      while low <= high
        case yield(self[mid])
        when 0
          return self[mid]
        when 1
          high = mid - 1
        when -1
          low = mid + 1
        else
          raise TypeError, 'wrong argument type (must be -1, 0, 1, true, or false)'
        end
        mid = low + (high - low) / 2
      end
      nil
    end
  end
end
