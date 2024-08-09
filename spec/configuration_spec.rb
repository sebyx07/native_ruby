# frozen_string_literal: true

RSpec.describe NativeRuby::Configuration do
  describe 'load_all_immutable_interators!' do
    it 'loads all immutable iterators' do
      NativeRuby.config do |c|
        c.load_all_immutable_iterators!
      end

      [1, 2, 3].each do |i|
        expect(i).not_to be_nil
      end

      result = [1, 2, 3].map do |i|
        i + 4
      end

      expect(result).to eq([5, 6, 7])
    end
  end
end
