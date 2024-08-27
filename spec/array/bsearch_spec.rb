# frozen_string_literal: true

RSpec.describe 'Array#bsearch' do
  before(:all) do
    class Array
      alias_method :original_bsearch, :bsearch
    end

    NativeRuby.config { |c| c.load(:class, { class: Array, method: :bsearch }) }
  end

  after(:all) do
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

    it 'works with non-numeric elements' do
      expect(%w[ant bear cat dog].bsearch { |x| x >= 'bear' }).to eq('bear')
    end

    it 'handles arrays with duplicate elements' do
      expect([1, 2, 2, 3, 3, 3, 4, 4, 5].bsearch { |x| x >= 3 }).to eq(3)
    end
  end

  context 'find-any mode' do
    it 'returns an element that satisfies the condition' do
      arr = [1, 2, 3, 4, 5]

      expect(arr.bsearch { |x| 3 >= x }).to eq(arr.original_bsearch { |x| 3 >= x })
    end

    it 'if no element satisfies the condition' do
      arr = [1, 2, 3, 4, 5]
      expect(arr.bsearch { |x| 6 >= x }).to eq(arr.original_bsearch { |x| 6 >= x })
    end

    it 'works with a large sorted array' do
      large_array = (1..1_000_000_00).to_a
      expect(large_array.bsearch { |x| 500_000 >= x }).to eq(large_array.original_bsearch { |x| 500_000 >= x })
    end

    it 'works with a large unsorted sorted array' do
      large_array = (1..1_000_000_00).to_a.shuffle
      expect(large_array.bsearch { |x| 500_000 >= x }).to eq(large_array.original_bsearch { |x| 500_000 >= x })
    end

    it 'handles edge cases correctly' do
      arr_1 = [1, 1, 1, 1, 1]
      arr_2 = [1, 2, 3, 4, 5]
      arr_3 = [1, 2, 3, 4, 5]

      expect(arr_1.bsearch { |x| 1 >= x }).to eq(arr_1.original_bsearch { |x| 1 >= x })
      expect(arr_2.bsearch { |x| 0 >= x }).to eq(arr_2.original_bsearch { |x| 0 >= x })
      expect(arr_3.bsearch { |x| 6 >= x }).to eq(arr_3.original_bsearch { |x| 6 >= x })
    end
  end

  it 'returns nil if the array is empty' do
    expect([].bsearch { |x| x > 1 }).to be_nil
  end

  it 'returns an Enumerator if no block is given' do
    enum = [1, 2, 3].bsearch
    expect(enum).to be_a(Enumerator)
    expect(enum.size).to eq(3)
  end

  it 'raises TypeError for invalid block return values' do
    expect { [1, 2, 3].bsearch { |x| "invalid" } }.to raise_error(TypeError)
  end

  it 'is consistent with Ruby\'s built-in bsearch' do
    arrays = [
      [1, 3, 5, 7, 9],
      [2, 4, 6, 8, 10],
      [1, 1, 2, 2, 3, 3],
      (1..100).to_a.shuffle,
      %w[apple banana cherry date]
    ]

    arrays.each do |arr|
      if arr.first.is_a?(String)
        expect(arr.bsearch { |x| x >= 'cherry' }).to eq(arr.original_bsearch { |x| x >= 'cherry' })
      else
        expect(arr.bsearch { |x| x >= 5 }).to eq(arr.original_bsearch { |x| x >= 5 })
      end
    end
  end

  it 'benchmarks native implementation against original' do
    array = (1..10_000_000).to_a
    shuffled_array = array.shuffle
    iterations = 10000000

    puts "Benchmark results sorted array (average over #{iterations} iterations):"
    Benchmark.bm(20) do |x|
      x.report('Original bsearch:') do
        iterations.times { array.original_bsearch { |n| n >= 54321 } }
      end
      x.report('Native bsearch:') do
        iterations.times { array.bsearch { |n| n >= 54321 } }
      end

      x.report('Correctness:') do
        iterations.times do
          raise "invalid" unless array.bsearch { |n| n >= 54321 } == array.original_bsearch { |n| n >= 54321 }
        end
      end
    end

    puts "Benchmark results shuffled (average over #{iterations} iterations):"
    Benchmark.bm(20) do |x|
      x.report('Original bsearch:') do
        iterations.times { shuffled_array.original_bsearch { |n| n >= 54321 } }
      end
      x.report('Native bsearch:') do
        iterations.times { shuffled_array.bsearch { |n| n >= 54321 } }
      end

      x.report('Correctness:') do
        iterations.times do
          raise "invalid" unless shuffled_array.bsearch { |n| n >= 54321 } == shuffled_array.original_bsearch { |n| n >= 54321 }
        end
      end
    end
  end
end
