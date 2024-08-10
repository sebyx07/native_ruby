# frozen_string_literal: true

RSpec.describe 'Array#any?' do
  before do
    class Array
      alias_method :original_any?, :any?
    end

    NativeRuby.config { |c| c.load(:class, { class: Array, method: :any? }) }
  end

  after do
    class Array
      alias_method :any?, :original_any?
    end
  end

  it 'returns true if any element matches the block' do
    expect([1, 2, 3].any? { |n| n > 2 }).to eq(true)
  end

  it 'returns false if no element matches the block' do
    expect([1, 2, 3].any? { |n| n > 3 }).to eq(false)
  end

  it 'empty array returns false' do
    expect([].any?).to eq(false)
  end

  it 'benchmarks native implementation against original' do
    array = (1..1_000_000).to_a

    puts 'Benchmark results:'
    Benchmark.bm(20) do |x|
      x.report('Original any?:') { array.original_any? { |n| n > 999_999 } }
      x.report('Native any?:') { array.any? { |n| n > 999_999 } }
    end
  end
end
