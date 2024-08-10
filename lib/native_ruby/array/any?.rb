# frozen_string_literal: true

class Array
  # Checks whether any element of the array meets a given condition.
  #
  # When called with a block, it returns `true` if the block returns a truthy value
  # for any element in the array. Otherwise, it returns `false`.
  #
  # When called without a block, it returns `true` if the array contains any elements
  # (i.e., it's not empty), and `false` otherwise.
  #
  # @yield [element] The block to test each element against
  # @yieldparam element [Object] Each element of the array
  # @yieldreturn [Boolean] Whether the element meets the condition
  #
  # @return [Boolean] `true` if any element meets the condition (or if the array is non-empty when called without a block), `false` otherwise
  #
  # @example With a block
  #   [1, 2, 3].any? { |element| element.even? } #=> true
  #   [1, 3, 5].any? { |element| element.even? } #=> false
  #
  # @example Without a block
  #   [1, 2, 3].any? #=> true
  #   [].any? #=> false
  def any?
    return self.length > 0 unless block_given?

    each { |element| return true if yield(element) }

    false
  end
end
