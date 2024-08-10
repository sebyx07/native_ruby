# frozen_string_literal: true

RSpec.describe 'Array#each_with_index' do
  before do
    class Array
      alias_method :original_each_with_index, :each_with_index
    end

    NativeRuby.config { |c| c.load(:iterators, { class: Array, method: :each_with_index, mutable: true }) }
  end

  after do
    class Array
      alias_method :each_with_index, :original_each_with_index
    end
  end

  it 'iterates the given block for each element with its index' do
    array = %w[a b c]
    result = []
    array.each_with_index { |item, index| result << [item, index] }
    expect(result).to eq([['a', 0], ['b', 1], ['c', 2]])
  end

  it 'returns self' do
    array = [1, 2, 3]
    expect(array.each_with_index { |item, index| }).to eq(array)
  end

  it 'does not modify the original array' do
    array = [1, 2, 3]
    array.each_with_index { |item, index| item * 2 }
    expect(array).to eq([1, 2, 3])
  end

  it 'works with an empty array' do
    result = []
    [].each_with_index { |item, index| result << [item, index] }
    expect(result).to be_empty
  end

  it 'returns an Enumerator if no block is given' do
    expect([1, 2, 3].each_with_index).to be_an(Enumerator)
  end

  it 'returns an Enumerator with the correct size' do
    enum = [1, 2, 3].each_with_index
    expect(enum.size).to eq(3)
  end

  it 'works with a large array' do
    large_array = (1..1_000_000).to_a
    count = 0
    large_array.each_with_index { |item, index| count += 1 if item == index + 1 }
    expect(count).to eq(1_000_000)
  end

  it 'benchmarks native implementation against original' do
    array = (1..1_000_000).to_a
    iterations = 10

    puts "Benchmark results (average over #{iterations} iterations):"
    Benchmark.bm(25) do |x|
      x.report('Original each_with_index:') do
        iterations.times { array.original_each_with_index { |item, index| } }
      end
      x.report('Native each_with_index:') do
        iterations.times { array.each_with_index { |item, index| } }
      end
    end
  end
end
