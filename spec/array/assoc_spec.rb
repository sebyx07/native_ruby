# frozen_string_literal: true

require 'benchmark'

RSpec.describe 'Array#assoc' do
  before do
    class Array
      alias_method :original_assoc, :assoc
    end

    NativeRuby.config { |c| c.load(:class, { class: Array, method: :assoc }) }
  end

  after do
    class Array
      alias_method :assoc, :original_assoc
    end
  end

  it 'returns the first element that matches the argument' do
    expect([[:foo, 1], [:bar, 2]].assoc(:foo)).to eq([:foo, 1])
  end

  it 'returns nil if no element matches the argument' do
    expect([[:foo, 1], [:bar, 2]].assoc(:baz)).to be_nil
  end

  it 'returns nil if the array is empty' do
    expect([].assoc(:foo)).to be_nil
  end

  it 'benchmarks native implementation against original' do
    array = Array.new(1_000_000) { |i| [i, i * 2] }

    puts 'Benchmark results:'
    Benchmark.bm(20) do |x|
      x.report('Original assoc:') { array.original_assoc(999_999) }
      x.report('Native assoc:') { array.assoc(999_999) }
    end
  end
end
