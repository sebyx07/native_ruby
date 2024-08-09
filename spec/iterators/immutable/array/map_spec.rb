# frozen_string_literal: true

RSpec.describe 'Immutable Array#map' do
  before do
    NativeRuby.config { |c| c.load(:iterators, { class: Array, method: :map }) }
  end

  it 'works' do
    expect([1, 2, 3].map { |x| x }).to eq([1, 2, 3])
  end
end
