require "test/unit"
require "lipisha/sdk"
require_relative "config"

class CardTest < Test::Unit::TestCase

  def setup
    @lipisha = Lipisha::Sdk::LipishaAPI.new(API_KEY, API_SIGNATURE, API_ENVIRONMENT)
  end

  def test_authorize_card_transaction
    omit_if((CARD_NUMBER.empty? and CARD_EXPIRY.empty?))
    response = @lipisha.authorize_card_transaction(CARD_ACCOUNT,
                                                   CARD_NUMBER,
                                                   CARD_ADDRESS1,
                                                   CARD_ADDRESS2,
                                                   CARD_EXPIRY,
                                                   CARD_NAMES,
                                                   CARD_COUNTRY,
                                                   CARD_STATE,
                                                   CARD_ZIP,
                                                   CARD_SECURITY_CODE,
                                                   CARD_AMOUNT,
                                                   CARD_CURRENCY)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
  end

  def test_complete_card_transaction
    omit_if((CARD_COMPLETE_TX_REF.empty? and CARD_COMPLETE_TX_INDEX.empty?))
    response = @lipisha.complete_card_transaction(CARD_COMPLETE_TX_INDEX,
                                                  CARD_COMPLETE_TX_REF)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
    assert_equal(CARD_COMPLETE_TX_INDEX, response.content["transaction_index"])
    assert_equal(CARD_COMPLETE_TX_REF, response.content["transaction_reference"])
  end

  def test_void_card_transaction
    omit_if((CARD_VOID_TX_REF.empty? and CARD_VOID_TX_INDEX.empty?))
    response = @lipisha.void_card_transaction(CARD_VOID_TX_INDEX,
                                              CARD_VOID_TX_REF)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
    assert_equal(CARD_VOID_TX_INDEX, response.content["transaction_index"])
    assert_equal(CARD_VOID_TX_REF, response.content["transaction_reference"])
  end

  def test_reverse_card_transaction
    omit_if((CARD_REVERSE_TX_REF.empty? and CARD_REVERSE_TX_INDEX.empty?))
    response = @lipisha.reverse_card_transaction(CARD_REVERSE_TX_INDEX,
                                                 CARD_REVERSE_TX_REF)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
    assert_equal(CARD_REVERSE_TX_INDEX, response.content["transaction_index"])
    assert_equal(CARD_REVERSE_TX_REF, response.content["transaction_reference"])
  end

end
