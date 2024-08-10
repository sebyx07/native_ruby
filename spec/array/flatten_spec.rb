# frozen_string_literal: true

RSpec.describe 'Array#flatten' do
  before do
    class Array
      alias_method :original_flatten, :flatten
    end

    NativeRuby.config { |c| c.load(:class, { class: Array, method: :flatten }) }
  end

  after do
    class Array
      alias_method :flatten, :original_flatten
    end
  end

  it 'flattens nested arrays' do
    expect([1, [2, 3, [4, 5]]].flatten).to eq([1, 2, 3, 4, 5])
  end

  it 'flattens to the specified level' do
    expect([1, [2, 3, [4, 5]]].flatten(1)).to eq([1, 2, 3, [4, 5]])
  end

  it 'returns a new array' do
    original = [1, [2, 3]]
    flattened = original.flatten
    expect(flattened).not_to be(original)
  end

  it 'does not modify the original array' do
    original = [1, [2, 3, [4, 5]]]
    original.flatten
    expect(original).to eq([1, [2, 3, [4, 5]]])
  end

  it 'handles empty arrays' do
    expect([].flatten).to eq([])
  end

  it 'handles arrays with no nested arrays' do
    expect([1, 2, 3].flatten).to eq([1, 2, 3])
  end

  it 'handles deeply nested arrays' do
    expect([1, [2, [3, [4, [5]]]]].flatten).to eq([1, 2, 3, 4, 5])
  end

  it 'handles arrays with nil elements' do
    expect([1, [2, nil, [3, nil]]].flatten).to eq([1, 2, nil, 3, nil])
  end

  it 'returns an Enumerator when called without arguments' do
    expect([1, [2, 3]].method(:flatten).arity).to eq(-1)
  end

  it 'works with a large array' do
    large_array = (1..1000).to_a.map { |i| [i, [i + 1000, [i + 2000]]] }
    flattened = large_array.flatten
    expect(flattened.size).to eq(3000)
    expect(flattened.first).to eq(1)
    expect(flattened.last).to eq(3000)
  end

  it 'benchmarks native implementation against original' do
    array = (1..10000).to_a.map { |i| [i, [i + 10000, [i + 20000]]] }
    iterations = 10

    puts "Benchmark results (average over #{iterations} iterations):"
    Benchmark.bm(20) do |x|
      x.report('Original flatten:') do
        iterations.times { array.original_flatten }
      end
      x.report('Native flatten:') do
        iterations.times { array.flatten }
      end
    end
  end
end
