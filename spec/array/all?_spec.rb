# frozen_string_literal: true

require 'benchmark'

RSpec.describe 'Array#all?' do
  before do
    class Array
      alias_method :original_all?, :all?
    end

    NativeRuby.config { |c| c.load(:class, { class: Array, method: :all? }) }
  end

  after do
    class Array
      alias_method :all?, :original_all?
    end
  end

  context 'when given a block' do
    it 'returns true if all elements satisfy the condition' do
      expect([1, 2, 3].all? { |x| x > 0 }).to be true
    end

    it 'returns false if any element does not satisfy the condition' do
      expect([1, 2, 3].all? { |x| x.even? }).to be false
    end

    it 'short-circuits on first false condition' do
      count = 0
      [1, 2, 3, 4, 5].all? do |x|
        count += 1
        x < 3
      end
      expect(count).to eq(3)
    end
  end

  context 'when not given a block' do
    it 'returns true if all elements are truthy' do
      expect([1, 'a', [1]].all?).to be true
    end

    it 'returns false if any element is falsey' do
      expect([1, nil, 3].all?).to be false
      expect([1, false, 3].all?).to be false
    end

    it 'short-circuits on first falsey element' do
      evaluated = []
      test_array = [
        -> { evaluated << 1; true },
        -> { evaluated << 2; false },
        -> { evaluated << 3; true }
      ]

      test_array.all?(&:call)

      expect(evaluated).to eq([1, 2])
    end
  end

  context 'with edge cases' do
    it 'returns true for an empty array' do
      expect([].all?).to be true
      expect([].all? { |x| x > 0 }).to be true
    end

    it 'works with arrays of different types' do
      expect([1, 'a', :symbol].all? { |x| x.to_s.length >= 1 }).to be true
    end
  end

  it 'does not modify the original array' do
    array = [1, 2, 3]
    array.all? { |x| x * 2 }
    expect(array).to eq([1, 2, 3])
  end

  it 'benchmarks native implementation against original' do
    array = (1..100_000).to_a
    iterations = 100

    puts "Benchmark results (average over #{iterations} iterations):"
    Benchmark.bm(20) do |x|
      x.report('Original all?:') do
        iterations.times { array.original_all? { |n| n > 0 } }
      end
      x.report('Native all?:') do
        iterations.times { array.all? { |n| n > 0 } }
      end
    end
  end
end
