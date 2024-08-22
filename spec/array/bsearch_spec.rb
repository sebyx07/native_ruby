# frozen_string_literal: true

RSpec.describe 'Array#bsearch' do
  before do
    class Array
      alias_method :original_bsearch, :bsearch
    end

    NativeRuby.config { |c| c.load(:class, { class: Array, method: :bsearch }) }
  end

  after do
    class Array
      alias_method :bsearch, :original_bsearch
    end
  end

  context 'find-minimum mode' do
    it 'returns the first element that satisfies the condition' do
      expect([1, 2, 3, 4, 5].bsearch { |x| x >= 3 }).to eq(3)
    end

    it 'returns nil if no element satisfies the condition' do
      expect([1, 2, 3, 4, 5].bsearch { |x| x > 5 }).to be_nil
    end

    it 'works with a large sorted array' do
      large_array = (1..1_000_000).to_a
      expect(large_array.bsearch { |x| x >= 500_000 }).to eq(500_000)
    end

    it 'handles edge cases correctly' do
      expect([1, 1, 1, 1, 1].bsearch { |x| x >= 1 }).to eq(1)
      expect([1, 2, 3, 4, 5].bsearch { |x| x >= 0 }).to eq(1)
      expect([1, 2, 3, 4, 5].bsearch { |x| x >= 6 }).to be_nil
    end
  end

  context 'find-any mode' do
    it 'returns an element that satisfies the condition' do
      result = [1, 2, 3, 4, 5].bsearch { |x| 3 <=> x }
      expect([2, 3, 4]).to include(result)
    end

    it 'returns nil if no element satisfies the condition' do
      expect([1, 2, 3, 4, 5].bsearch { |x| 6 <=> x }).to be_nil
    end

    it 'works with a large sorted array' do
      large_array = (1..1_000_000).to_a
      result = large_array.bsearch { |x| 500_000 <=> x }
      expect([499_999, 500_000, 500_001]).to include(result)
    end
  end

  it 'returns nil if the array is empty' do
    expect([].bsearch { |x| x > 1 }).to be_nil
  end

  it 'benchmarks native implementation against original' do
    array = (1..10_000_000).to_a
    iterations = 10000000

    puts "Benchmark results (average over #{iterations} iterations):"
    Benchmark.bm(20) do |x|
      x.report('Original bsearch:') do
        iterations.times { array.original_bsearch { |n| n <=> 9_999_999 } }
      end
      x.report('Native bsearch:') do
        iterations.times { array.bsearch { |n| n <=> 9_999_999 } }
      end
    end
  end
end
