# frozen_string_literal: true

module NativeRuby
  class Configuration
    def load_all_immutable_interators!
      Dir.glob(File.join(File.dirname(__FILE__), 'iterators', 'immutable', '**', '*.rb')).each do |file|
        require file
      end
    end

    def load_all_mutable_interators!
      Dir.glob(File.join(File.dirname(__FILE__), 'iterators', 'mutable', '**', '*.rb')).each do |file|
        require file
      end
    end

    def load(type, options = {})
      klass = options[:class]
      method = options[:method]
      mutable = options[:mutable]
      mutable_path = mutable ? 'mutable' : 'immutable'

      path = File.join(File.dirname(__FILE__), type, mutable_path, "#{klass.downcase}", "#{method}.rb")
      raise "Cannot load #{mutable_path} #{klass}.#{method}" unless File.exist?(path)

      require path
    end
  end
end
