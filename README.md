# VCRResetUtils

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'VCR_reset_utils', git: 'git@github.com:chargify/VCR_reset_utils.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install VCR_reset_utils

## Usage

**Rake tasks:**
* `rake 'vcr:files_to_reset[square]'` - It returns all test files to rerun.
* `rake 'vcr:reset[square]'` - It reruns all test files where was used VCR for the gateway
* `rake 'vcr:files_with_tests_to_skip[square]'` - It returns all test files with tests which skip VCR reset
* `rake vcr:key_words` - It returns all keywords which you can use in the rake task

**Skip VCR reset:**
You can skip VCR reset for test if you add `VCRResetUtils.skip` to test:
``` ruby
it "test to skip vcr reset" do
  VCRResetUtils.skip
  [...]
end
```

**You can run one test with the reset option:**
`RECORD_VCR=1 bundle exec rspec <path_to_test>`

**Configuration:**

* You can modify `key_words dictionary`.
* You can allow key words without dictionary.

In `config/initializers/vcr_reset_utils.rb`

``` ruby
VCRResetUtils.configure do |config|
  config.allow_key_words_without_dictionary = false
  config.key_words_dictionary = {
    authorize_net: '"authorizenet\\|authorize_net\\|authorize net"',
    stripe: "stripe",
    square: "square",
    moneris: "moneris | grep -v moneris_us",
    [...]
  }
end
      
```

## More information:
**Pattern:** I am looking for files with content to be found _keyword_ (name of gateway) and `VCR\.use_cassette\|vcr_base_path\|vcr_path\|cassette_name` words. And for these files, I rerun tests and remove cassettes for all tests that use VCR and don't have `VCRResetUtils.skip`.

**Disadvantage:** If two gateways are tested in one file VCR will be resetting for both.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/VCR_reset_utils.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
