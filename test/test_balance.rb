require "test/unit"
require "lipisha/sdk"
require_relative "config"

class BalanceTest < Test::Unit::TestCase

  def setup
    @lipisha = Lipisha::Sdk::LipishaAPI.new(API_KEY, API_SIGNATURE, API_ENVIRONMENT)
  end

  def test_get_balance
    response = @lipisha.get_balance()
    puts(response)
    assert_not_nil response
    assert_not_nil response.status
    assert_not_nil response.status_code
    assert_not_nil response.content
    assert_equal(STATUS_SUCCESS, response.status)
  end

  def test_get_float
    omit_if(FLOAT_ACCOUNT.empty?)
    response = @lipisha.get_float(FLOAT_ACCOUNT)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
    assert_equal(FLOAT_ACCOUNT, response.content["account_number"])
  end


end
