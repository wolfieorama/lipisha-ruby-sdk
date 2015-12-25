# IPN Integration examples


This is an examples of Lipisha IPN integration for rails.

This assumes that you have configured an IPN URL for API callbacks.

IPN: Instant Payment Notification

## Usage

The bulk of the logic happens in the [IPN Controller](https://github.com/lipisha/lipisha-ruby-sdk/tree/master/examples/app/controllers/ipn_controller.rb).

For production usage, handling IPN callbacks should be mapped to records in permanent storage.

Adjust the controller settings to load your `API_KEY` and `API_SIGNATURE`.


## Running

Make sure you have `Ruby` and the `bundler` gem installed

```shell
gem install bundler
bundle install
./bin/rails server
```

Test HTTP requests may then be POSTED test parameters to

    http://localhost:3000/IPN/
