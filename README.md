# NativeRuby 🚀

NativeRuby is a standard library for Ruby implemented in Ruby, designed to take advantage of the YJIT compiler for improved performance. It provides optimized, native Ruby implementations of various core methods and iterators while maintaining the familiar Ruby API. 🔥

## Important Note on Performance ⚠️

**The performance improvements provided by NativeRuby are primarily seen when YJIT is enabled.** Without YJIT, you may not notice significant performance gains. For the best results, always use NativeRuby with YJIT enabled.

## Requirements 📋

- Ruby version: >= 3.0.0
- YJIT enabled for optimal performance

## Installation 💎

Add this line to your application's Gemfile:

```ruby
gem 'native_ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install native_ruby

## Usage 🛠️

To use NativeRuby in your project, you first need to require it:

```ruby
require 'native_ruby'
```

Then, you can configure which optimized methods you want to use:

```ruby
NativeRuby.config do |c|
  # Load all immutable iterators
  c.load_all_immutable_iterators!

  # Load all mutable iterators
  c.load_all_mutable_iterators!

  # Load all optimized methods for a specific class
  c.require_all_for_class!(Array)

  # Load a specific method for a class
  c.load(:class, { class: Array, method: :bsearch })

  # Load a specific iterator (mutable or immutable)
  c.load(:iterators, { class: Array, method: :each, mutable: false })
end
```

### Configuration Options ⚙️

- `load_all_immutable_iterators!`: Loads all immutable iterator optimizations.
- `load_all_mutable_iterators!`: Loads all mutable iterator optimizations.
- `require_all_for_class!(klass)`: Loads all optimized methods for a given class.
- `load(type, options)`: Loads a specific optimized method or iterator.
    - For class methods: `type: :class, class: ClassName, method: :method_name`
    - For iterators: `type: :iterators, class: ClassName, method: :method_name, mutable: boolean`

## YJIT and Performance 🚀

NativeRuby is specifically designed to work with YJIT (Yet Another Just-In-Time Compiler for Ruby). The performance improvements are primarily realized when YJIT is enabled.

To use NativeRuby with YJIT and see the performance benefits:

1. Ensure you're using Ruby 3.1 or later.
2. Enable YJIT when running your Ruby script:

```
ruby --yjit your_script.rb
```

Without YJIT enabled, you may not see significant performance improvements. Always use NativeRuby with YJIT for optimal results.

## Development 🔧

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing 🤝

Bug reports and pull requests are welcome on GitHub at https://github.com/sebyx07/native_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sebyx07/native_ruby/blob/master/CODE_OF_CONDUCT.md).

## License 📄

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct 🤓

Everyone interacting in the NativeRuby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sebyx07/native_ruby/blob/master/CODE_OF_CONDUCT.md).

## Author 👨‍💻

- **sebi** - [GitHub](https://github.com/sebyx07)

## Links 🔗

- [Homepage](https://github.com/sebyx07/native_ruby)
- [Source Code](https://github.com/sebyx07/native_ruby)