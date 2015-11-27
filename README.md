# Lipisha::Sdk

This gem provides bindings for Lipisha Payments API (http://developers.lipisha.com)

## Documentation

http://www.rubydoc.info/github/lipisha/lipisha-ruby-sdk/master/Lipisha/Sdk/LipishaAPI

## Features

- Send money
- Acknowledge transactions
- Send SMS
- Get Float
- Get Balance
- Charge card transactions
- Search transactions
- Search customers
- Add users
- Add payment accounts and withdrawal accounts

## Installation

Add this line to your application's Gemfile:

    gem 'lipisha-sdk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lipisha-sdk

## Usage

```ruby
require "lipisha/sdk"

lipisha = Lipisha::Sdk::LipishaAPI.new("<YOUR API kEY>", "YOUR API SIGNATURE", "<ENVIRONMENT>")
# Enviroment may either be _live_ for production environment or _test_ for the lipisha sandbox.

response = lipisha.get_balance()
puts(response.status)
puts(response.status_code)
# This is a map of the content response
# See the Lipisha API documentation for available metadata
puts(response.content)
puts(response.json)

# Sending money
response = lipisha.send_money("039XXX", "0722123456", 200)
```

## IPN Examples

IPN Integration examples for Rails are in the examples directory

https://github.com/lipisha/lipisha-ruby-sdk/tree/master/examples

## Running Tests

Edit the test configuration in `test/config.rb`

Run all tests

```shell
bundle exec rake
```

Run a particular test

```
bundle exec rake TEST=test/<filename>
```

e.g. Balance tests

```
 bundle exec rake TEST=test/test_balance
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
