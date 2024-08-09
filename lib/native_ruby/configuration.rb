# frozen_string_literal: true

module NativeRuby
  class Configuration
    def load_all_immutable_iterators!
      Dir.glob(File.join(File.dirname(__FILE__), 'iterators', 'immutable', '**', '*.rb')).each do |file|
        require file
      end
    end

    def load_all_mutable_iterators!
      Dir.glob(File.join(File.dirname(__FILE__), 'iterators', 'mutable', '**', '*.rb')).each do |file|
        require file
      end
    end

    def load(type, options = {})
      klass = options[:class]
      method = options[:method]
      mutable = options[:mutable]
      mutable_path = mutable ? 'mutable' : 'immutable'

      path = File.join(File.dirname(__FILE__), type.to_s, mutable_path, "#{klass.name.downcase}", "#{method}.rb")
      raise "Cannot load #{mutable_path} #{klass}.#{method}" unless File.exist?(path)

      require path
    end
  end
end
