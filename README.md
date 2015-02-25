# Liability

Check whether the Ruby versions you use in your apps are a liability.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'liability'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install liability

## Usage

To check the current directory for any Ruby liability:
```bash
liability
```

To recursively check every sub-directory for a Ruby liability:
```bash
liability -r .
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/olivierlacan/liability/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
