require "test/unit"
require "lipisha/sdk"
require_relative "config"

class AccountsTest < Test::Unit::TestCase

  def setup
    @lipisha = Lipisha::Sdk::LipishaAPI.new(API_KEY, API_SIGNATURE, API_ENVIRONMENT)
  end

  def test_create_payment_account
    omit_if((ACCOUNT_NAME.empty? and ACCOUNT_ADMIN.empty?))
    response = @lipisha.create_payment_account(1, ACCOUNT_NAME, ACCOUNT_ADMIN)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
  end

  def test_create_user
    omit_if(TEST_USER_ROLE.empty?)
    response = @lipisha.create_user(TEST_USER_NAMES,
                                    TEST_USER_ROLE,
                                    TEST_USER_MOBILE,
                                    TEST_USER_EMAIL,
                                    TEST_USER_LOGIN,
                                    TEST_USER_PASSWORD)
    puts(response)
    assert_not_nil response
    assert_equal(STATUS_SUCCESS, response.status)
  end


end
