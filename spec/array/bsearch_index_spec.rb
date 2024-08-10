# frozen_string_literal: true

RSpec.describe 'Array#bsearch_index' do
  before do
    class Array
      alias_method :original_bsearch_index, :bsearch_index
    end

    NativeRuby.config { |c| c.load(:class, { class: Array, method: :bsearch_index }) }
  end

  after do
    class Array
      alias_method :bsearch_index, :original_bsearch_index
    end
  end

  context 'find-minimum mode' do
    it 'returns the index of the first element that satisfies the condition' do
      expect([1, 2, 3, 4, 5].bsearch_index { |x| x >= 3 }).to eq(2)
    end

    it 'returns nil if no element satisfies the condition' do
      expect([1, 2, 3, 4, 5].bsearch_index { |x| x > 5 }).to be_nil
    end

    it 'works with a large sorted array' do
      large_array = (1..1_000_000).to_a
      expect(large_array.bsearch_index { |x| x >= 500_000 }).to eq(499_999)
    end

    it 'handles edge cases correctly' do
      expect([1, 1, 1, 1, 1].bsearch_index { |x| x >= 1 }).to eq(0)
      expect([1, 2, 3, 4, 5].bsearch_index { |x| x >= 0 }).to eq(0)
      expect([1, 2, 3, 4, 5].bsearch_index { |x| x >= 6 }).to be_nil
    end
  end

  context 'find-any mode' do
    it 'returns the index of an element that satisfies the condition' do
      result = [1, 2, 3, 4, 5].bsearch_index { |x| 3 <=> x }
      expect([1, 2, 3]).to include(result)
    end

    it 'returns nil if no element satisfies the condition' do
      expect([1, 2, 3, 4, 5].bsearch_index { |x| 6 <=> x }).to be_nil
    end

    it 'works with a large sorted array' do
      large_array = (1..1_000_000).to_a
      result = large_array.bsearch_index { |x| 500_000 <=> x }
      expect([499_998, 499_999, 500_000]).to include(result)
    end
  end

  it 'returns nil if the array is empty' do
    expect([].bsearch_index { |x| x > 1 }).to be_nil
  end

  it 'returns an Enumerator if no block is given' do
    expect([1, 2, 3, 4, 5].bsearch_index).to be_an(Enumerator)
  end

  it 'benchmarks native implementation against original' do
    array = (1..10_000_000).to_a
    iterations = 100000

    puts "Benchmark results (average over #{iterations} iterations):"
    Benchmark.bm(20) do |x|
      x.report('Original bsearch_index:') do
        iterations.times { array.original_bsearch_index { |n| n <=> 9_999_999 } }
      end
      x.report('Native bsearch_index:') do
        iterations.times { array.bsearch_index { |n| n <=> 9_999_999 } }
      end
    end
  end
end
