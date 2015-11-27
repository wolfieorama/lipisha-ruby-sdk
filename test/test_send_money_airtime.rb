require "test/unit"
require "lipisha/sdk"
require_relative "config"

class SendMoneyAirtimeTest < Test::Unit::TestCase

  def setup
    @lipisha = Lipisha::Sdk::LipishaAPI.new(API_KEY, API_SIGNATURE, API_ENVIRONMENT)
  end

  def test_send_money
    omit_if((PAYOUT_AMOUNT.nil? and PAYOUT_ACCOUNT.empty? and PAYOUT_MOBILE_NUMBER.empty?))
    response = @lipisha.send_money(PAYOUT_ACCOUNT, PAYOUT_MOBILE_NUMBER, PAYOUT_AMOUNT)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
  end

  def test_send_airtime
    omit_if((AIRTIME_AMOUNT.nil? and AIRTIME_NETWORK.empty? and AIRTIME_MOBILE_NUMBER.empty?))
    response = @lipisha.send_airtime(AIRTIME_ACCOUNT, AIRTIME_MOBILE_NUMBER, AIRTIME_AMOUNT, AIRTIME_NETWORK)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
    assert_equal(AIRTIME_MOBILE_NUMBER, response.content["mobile_number"])
    assert_equal(AIRTIME_AMOUNT, response.content["amount"])
  end
end
