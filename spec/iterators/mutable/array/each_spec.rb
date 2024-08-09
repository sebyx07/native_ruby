# frozen_string_literal: true

RSpec.describe 'Mutable Array#each' do
  before do
    NativeRuby.config { |c| c.load(:iterators, { class: Array, method: :each, mutable: true }) }
  end

  it 'works' do
    expect([1, 2, 3].each { |x| x }).to eq([1, 2, 3])
  end
end
