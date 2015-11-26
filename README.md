# Lipisha::Sdk

This gem provides bindings for Lipisha Payments API (http://developers.lipisha.com)

---

**Note that this package is in development. - It will be published on rubygems and this notice removed shortly**

---

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
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
