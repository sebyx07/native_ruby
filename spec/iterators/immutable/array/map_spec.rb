# frozen_string_literal: true

require 'benchmark'

RSpec.describe 'Immutable Array#map' do
  before do
    class Array
      alias_method :original_map, :map
    end

    NativeRuby.config { |c| c.load(:iterators, { class: Array, method: :map, mutable: false }) }
  end

  after do
    # Restore the original method after tests
    class Array
      alias_method :map, :original_map
    end
  end

  it 'returns a new array with the results of running block once for every element' do
    expect([1, 2, 3].map { |x| x * 2 }).to eq([2, 4, 6])
  end

  it 'does not modify the original array' do
    original = [1, 2, 3]
    original.map { |x| x * 2 }
    expect(original).to eq([1, 2, 3])
  end

  it 'works with an empty array' do
    expect([].map { |x| x * 2 }).to eq([])
  end

  it 'handles non-numeric operations' do
    expect(%w[a b c].map(&:upcase)).to eq(%w[A B C])
  end

  it 'works with a large array' do
    large_array = (1..1_000_000).to_a
    result = large_array.map { |x| x + 1 }
    expect(result.first).to eq(2)
    expect(result.last).to eq(1_000_001)
    expect(result.size).to eq(1_000_000)
  end

  it 'returns an Enumerator if no block is given' do
    expect([1, 2, 3].map).to be_an(Enumerator)
  end

  it 'handles edge cases correctly' do
    expect([nil, false, true].map { |x| x }).to eq([nil, false, true])
    expect([[]].map { |x| x }).to eq([[]])
  end

  it 'benchmarks native implementation against original' do
    array = (1..1_000_000).to_a
    iterations = 10

    puts "Benchmark results (average over #{iterations} iterations):"
    Benchmark.bm(20) do |x|
      x.report('Original map:') do
        iterations.times { array.original_map { |n| n * 2 } }
      end
      x.report('Native map:') do
        iterations.times { array.map { |n| n * 2 } }
      end
    end
  end
end
