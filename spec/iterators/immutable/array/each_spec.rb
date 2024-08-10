# frozen_string_literal: true

RSpec.describe 'Immutable Array#each' do
  before do
    class Array
      alias_method :original_each, :each
    end

    NativeRuby.config { |c| c.load(:iterators, { class: Array, method: :each, mutable: false }) }
  end

  after do
    # Restore the original method after tests
    class Array
      alias_method :each, :original_each
    end
  end

  it 'iterates over each element' do
    result = []
    [1, 2, 3].each { |x| result << x }
    expect(result).to eq([1, 2, 3])
  end

  it 'returns the original array' do
    expect([1, 2, 3].each { |x| x }).to eq([1, 2, 3])
  end

  it 'does not modify the original array' do
    original = [1, 2, 3]
    original.each { |x| x * 2 }
    expect(original).to eq([1, 2, 3])
  end

  it 'works with an empty array' do
    result = []
    [].each { |x| result << x }
    expect(result).to be_empty
  end

  it 'handles large arrays' do
    large_array = (1..1_000_000).to_a
    count = 0
    large_array.each { |_| count += 1 }
    expect(count).to eq(1_000_000)
  end

  it 'returns an Enumerator if no block is given' do
    expect([1, 2, 3].each).to be_an(Enumerator)
  end

  it 'benchmarks native implementation against original' do
    array = (1..1_000_000).to_a
    iterations = 100

    puts "Benchmark results (average over #{iterations} iterations):"
    Benchmark.bm(20) do |x|
      x.report('Original each:') do
        iterations.times { array.original_each { |n| n * 2 } }
      end
      x.report('Native each:') do
        iterations.times { array.each { |n| n * 2 } }
      end
    end
  end
end
