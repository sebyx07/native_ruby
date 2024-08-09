# frozen_string_literal: true

require_relative 'native_ruby/version'

module NativeRuby
  class Error < StandardError; end
  def self.config
    @config ||= Configuration.new
    yield @config if block_given?
  end
end
