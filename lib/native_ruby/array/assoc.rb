# frozen_string_literal: true

class Array
  # Searches through an array whose elements are also arrays.
  # Compares `obj` with the first element of each contained array
  # using `==`.
  #
  # Returns the first contained array that matches (that is, the first
  # array whose first element is `obj`). Returns `nil` if no match is found.
  #
  # @param obj [Object] The object to search for as the first element of the subarrays
  #
  # @return [Array, nil] The first array whose first element matches `obj`, or `nil` if not found
  #
  # @example
  #   arr = [["colors", "red", "blue", "green"],
  #          ["letters", "a", "b", "c"]]
  #   arr.assoc("letters")  #=> ["letters", "a", "b", "c"]
  #   arr.assoc("foo")      #=> nil
  #
  # @note This method expects the receiver to be an array of arrays. If the receiver
  #       is not an array of arrays, the behavior is undefined.
  #
  # @see Array#rassoc for searching based on the second element of subarrays
  def assoc(obj)
    each { |element| return element if element.first == obj }

    nil
  end
end
