require "test/unit"
require "lipisha/sdk"
require_relative "config"

class BalanceTest < Test::Unit::TestCase

  def setup
    @lipisha = Lipisha::Sdk::LipishaAPI.new(API_KEY, API_SIGNATURE, API_ENVIRONMENT)
  end

  def test_get_transactions
    response = @lipisha.get_transactions(transcation_amount_minimum=10.0,
                                         transaction_amount_maximum=200.0)
    puts(response)
    assert_not_nil response
    assert_not_nil response.status
    assert_not_nil response.status_code
    assert_not_nil response.content
    assert_equal(STATUS_SUCCESS, response.status)
  end

  def test_get_customers
    response = @lipisha.get_customers(customer_payments_minimum=20.0)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
  end

  def test_confirm_transaction
    omit_if(TRANSACTION_ID_CONFIRM.empty?)
    response = @lipisha.confirm_transaction(TRANSACTION_ID_CONFIRM)
    puts(response)
    assert_not_nil response
    assert_not_nil response.content
    assert_not_nil response.status
    assert_equal(STATUS_SUCCESS, response.status)
    assert_equal(STATUS_CONFIRMED, response.content["transaction_status"])
  end

  def test_reverse_transaction
    omit_if(TRANSACTION_ID_REVERSE.empty?)
    response = @lipisha.reverse_transaction(TRANSACTION_ID_REVERSE)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
  end
end
