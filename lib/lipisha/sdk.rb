require "lipisha/sdk/version"
require "net/http"
require "uri"
require "json"

module Lipisha
  module Sdk
    class APIResponse
      attr_reader :status
      attr_reader :status_code
      attr_reader :status_description
      attr_reader :content
      attr_reader :json

      ##
      # Initializes lipisha API respnse
      #
      # === Attributes
      #
      # * +status+ - status of the api call e.g. Success
      # * +status_code+ - numeric status code of the api call
      # * +status_description+ - Verbose status code description
      # * +content+ - content section of api call response
      # * +json+ - Raw JSON response (Hashmap)
      def initialize(status, status_code, status_description, content, json)
        @status = status
        @status_code = status_code
        @status_description = status_description
        @content = content
        @json = json
      end

      def to_s
        @json.to_s
      end
    end
    ##
    # This class defines API bindings for lipisha payments.
    # Each methods responds with an APIResponse object which
    # may be introspected for the status of the call.

    class LipishaAPI
      LIVE_API_BASE_URL = "https://www.lipisha.com/payments/accounts/index.php/v2/api/"
      SANDBOX_API_BASE_URL = "http://developer.lipisha.com/index.php/v2/api/"
      DEFAULT_API_VERSION = "1.3.0"
      DEFAULT_API_TYPE = "Callback"

      ##
      # Initialize Lipisha API connector
      # API credentials can be acquired from your Lipisha account under settings.
      #
      # === Attributes
      #
      # * +api_key+ - API Key to use to connect to Lipisha
      # * +api_signature+ - API Signature to use when connecting
      # * +environment+ - either "live" for production environment or "test"
      #                   for the sandbox
      #
      def initialize(api_key, api_signature, environment = "LIVE")
        @api_key = api_key
        @api_signature = api_signature
        $environment = environment.upcase
        # Set API base environment for selected environment
        case $environment
        when "LIVE"
          @api_base = LIVE_API_BASE_URL
        when "TEST"
          @api_base = SANDBOX_API_BASE_URL
        else
          fail "`environment` must be either LIVE or TEST"
        end
      end

      def execute(api_endpoint, api_parameters)
        api_url = @api_base + api_endpoint
        uri = URI.parse(api_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")
        request = Net::HTTP::Post.new(uri.request_uri)
        # Set api key and signature
        api_parameters["api_key"] = @api_key
        api_parameters["api_signature"] = @api_signature
        api_parameters["api_type"] = DEFAULT_API_TYPE
        api_parameters["api_version"] = DEFAULT_API_VERSION
        request.set_form_data(api_parameters)
        response = http.request(request)
        response_map = JSON.parse(response.body)
        api_response = APIResponse.new(response_map["status"]["status"],
                                       response_map["status"]["status_code"],
                                       response_map["status"]["status_description"],
                                       response_map["content"],
                                       response_map)
        api_response
      end

      ##
      # Gets available balance in Lipisha main account
      #
      # {Full docs - get_balance}[http://developer.lipisha.com/index.php/app/launch/api_get_balance]
      #
      def get_balance
        endpoint = "get_balance"
        parameters = {}
        execute(endpoint, parameters)
      end

      ##
      # Gets available balance in float account
      #
      # {Full docs - get_float}[http://developer.lipisha.com/index.php/app/launch/api_get_float]
      #
      # ==== Attributes
      #
      # * +account_number+ - float account number to look up
      #
      def get_float(account_number)
        endpoint = "get_float"
        parameters = { "account_number" => account_number }
        execute(endpoint, parameters)
      end

      ##
      # Send money
      #
      # {Full docs - send_money}[http://developer.lipisha.com/index.php/app/launch/api_send_money]
      #
      # ==== Attributes
      #
      # * +account_number+
      # * +mobile_number+
      # * +amount+
      #
      #
      def send_money(account_number, mobile_number, amount)
        endpoint = "send_money"
        parameters = { "account_number" => account_number, "mobile_number" => mobile_number, "amount" => amount }
        execute(endpoint, parameters)
      end

      ##
      # Send sms
      #
      # {Full docs - send_sms}[http://developer.lipisha.com/index.php/app/launch/api_send_sms]
      #
      # ==== Attributes
      #
      # * +mobile_number+
      # * +message+
      #
      #
      def send_sms(mobile_number, message)
        endpoint = "send_sms"
        parameters = { "mobile_number" => mobile_number, "message" => message }
        execute(endpoint, parameters)
      end

      ##
      # Acknowledge transaction
      #
      # {Full docs - acknowledge_transaction}[http://developer.lipisha.com/index.php/app/launch/api_acknowledge_transaction]
      #
      # ==== Attributes
      #
      # * +transaction+
      #
      #
      def acknowledge_transaction(transaction)
        endpoint = "acknowledge_transaction"
        parameters = { "transaction" => transaction }
        execute(endpoint, parameters)
      end

      ##
      # Confirm transaction
      #
      # {Full docs - confirm_transaction}[http://developer.lipisha.com/index.php/app/launch/api_confirm_transaction]
      #
      # ==== Attributes
      #
      # * +transaction+
      #
      #
      def confirm_transaction(transaction)
        endpoint = "confirm_transaction"
        parameters = { "transaction" => transaction }
        execute(endpoint, parameters)
      end

      ##
      # Reverse transaction
      #
      # {Full docs - reverse_transaction}[http://developer.lipisha.com/index.php/app/launch/api_reverse_transaction]
      #
      # ==== Attributes
      #
      # * +transaction+
      #
      #
      def reverse_transaction(transaction)
        endpoint = "reverse_transaction"
        parameters = { "transaction" => transaction }
        execute(endpoint, parameters)
      end

      ##
      # Send airtime
      #
      # {Full docs - send_airtime}[http://developer.lipisha.com/index.php/app/launch/api_send_airtime]
      #
      # ==== Attributes
      #
      # * +account_number+
      # * +mobile_number+
      # * +amount+
      # * +network+
      #
      #
      def send_airtime(account_number, mobile_number, amount, network)
        endpoint = "send_airtime"
        parameters = { "account_number" => account_number,
                       "mobile_number" => mobile_number,
                       "amount" => amount,
                       "network" => network }
        execute(endpoint, parameters)
      end

      ##
      # Create user
      #
      # {Full docs - create_user}[http://developer.lipisha.com/index.php/app/launch/api_create_user]
      #
      # ==== Attributes
      #
      # * +full_name+
      # * +role+
      # * +mobile_number+
      # * +email+
      # * +user_name+
      # * +password+
      #
      #
      def create_user(full_name, role, mobile_number, email, user_name, password)
        endpoint = "create_user"
        parameters = { "full_name" => full_name,
                       "role" => role,
                       "mobile_number" => mobile_number,
                       "email" => email,
                       "user_name" => user_name,
                       "password" => password }
        execute(endpoint, parameters)
      end

      ##
      # Update user
      #
      # {Full docs - update_user}[http://developer.lipisha.com/index.php/app/launch/api_update_user]
      #
      # ==== Attributes
      #
      # * +full_name+
      # * +role+
      # * +mobile_number+
      # * +email+
      # * +user_name+
      #
      #
      def update_user(full_name, role, mobile_number, email, user_name)
        endpoint = "update_user"
        parameters = { "full_name" => full_name,
                       "role" => role,
                       "mobile_number" => mobile_number,
                       "email" => email,
                       "user_name" => user_name }
        execute(endpoint, parameters)
      end

      ##
      # Create payment account
      #
      # {Full docs - create_payment_account}[http://developer.lipisha.com/index.php/app/launch/api_create_payment_account]
      #
      # ==== Attributes
      #
      # * +transaction_account_type+
      # * +transaction_account_name+
      # * +transaction_account_manager+
      #
      #
      def create_payment_account(transaction_account_type,
                                 transaction_account_name,
                                 transaction_account_manager)
        endpoint = "create_payment_account"
        parameters = { "transaction_account_type" => transaction_account_type,
                       "transaction_account_name" => transaction_account_name,
                       "transaction_account_manager" => transaction_account_manager }
        execute(endpoint, parameters)
      end

      ##
      # Create withdrawal account
      #
      # {Full docs - create_withdrawal_account}[http://developer.lipisha.com/index.php/app/launch/api_create_withdrawal_account]
      #
      # ==== Attributes
      #
      # * +transaction_account_type+
      # * +transaction_account_name+
      # * +transaction_account_number+
      # * +transaction_account_bank_name+
      # * +transaction_account_bank_branch+
      # * +transaction_account_bank_address+
      # * +transaction_account_swift_code+
      # * +transaction_account_manager+
      #
      #
      def create_withdrawal_account(transaction_account_type,
                                    transaction_account_name,
                                    transaction_account_number,
                                    transaction_account_bank_name,
                                    transaction_account_bank_branch,
                                    transaction_account_bank_address,
                                    transaction_account_swift_code,
                                    transaction_account_manager)
        endpoint = "create_withdrawal_account"
        parameters = { "transaction_account_type" => transaction_account_type,
                       "transaction_account_name" => transaction_account_name,
                       "transaction_account_number" => transaction_account_number,
                       "transaction_account_bank_name" => transaction_account_bank_name,
                       "transaction_account_bank_branch" => transaction_account_bank_branch,
                       "transaction_account_bank_address" => transaction_account_bank_address,
                       "transaction_account_swift_code" => transaction_account_swift_code,
                       "transaction_account_manager" => transaction_account_manager }
        execute(endpoint, parameters)
      end

      ##
      # Get transactions
      #
      # {Full docs - get_transactions}[http://developer.lipisha.com/index.php/app/launch/api_get_transactions]
      #
      # ==== Attributes
      #
      # * +transaction+
      # * +transaction_type+
      # * +transaction_method+
      # * +transaction_date_start+
      # * +transaction_date_end+
      # * +transaction_account_name+
      # * +transaction_account_number+
      # * +transaction_reference+
      # * +transaction_amount_minimum+
      # * +transaction_amount_maximum+
      # * +transaction_status+
      # * +transaction_name+
      # * +transaction_mobile_number+
      # * +transaction_email+
      # * +limit+
      # * +offset+
      #
      #
      def get_transactions(transaction = "",
                           transaction_type = "",
                           transaction_method = "",
                           transaction_date_start = "",
                           transaction_date_end = "",
                           transaction_account_name = "",
                           transaction_account_number = "",
                           transaction_reference = "",
                           transaction_amount_minimum = "",
                           transaction_amount_maximum = "",
                           transaction_status = "",
                           transaction_name = "",
                           transaction_mobile_number = "",
                           transaction_email = "",
                           limit = 100,
                           offset = 0)
        endpoint = "get_transactions"
        parameters = { "transaction" => transaction,
                       "transaction_type" => transaction_type,
                       "transaction_method" => transaction_method,
                       "transaction_date_start" => transaction_date_start,
                       "transaction_date_end" => transaction_date_end,
                       "transaction_account_name" => transaction_account_name,
                       "transaction_account_number" => transaction_account_number,
                       "transaction_reference" => transaction_reference,
                       "transaction_amount_minimum" => transaction_amount_minimum,
                       "transaction_amount_maximum" => transaction_amount_maximum,
                       "transaction_status" => transaction_status,
                       "transaction_name" => transaction_name,
                       "transaction_mobile_number" => transaction_mobile_number,
                       "transaction_email" => transaction_email,
                       "limit" => limit,
                       "offset" => offset }
        execute(endpoint, parameters)
      end

      ##
      # Get customers
      #
      # {Full docs - get_customers}[http://developer.lipisha.com/index.php/app/launch/api_get_customers]
      #
      # ==== Attributes
      #
      # * +customer_name+
      # * +customer_mobile_number+
      # * +customer_email+
      # * +customer_first_payment_from+
      # * +customer_first_payment_to+
      # * +customer_last_payment_from+
      # * +customer_last_payment_to+
      # * +customer_payments_minimum+
      # * +customer_payments_maximum+
      # * +customer_total_spent_minimum+
      # * +customer_total_spent_maximum+
      # * +customer_average_spent_minimum+
      # * +customer_average_spent_maximum+
      # * +limit+
      # * +offset+
      #
      #
      def get_customers(customer_name = "",
                        customer_mobile_number = "",
                        customer_email = "",
                        customer_first_payment_from = "",
                        customer_first_payment_to = "",
                        customer_last_payment_from = "",
                        customer_last_payment_to = "",
                        customer_payments_minimum = "",
                        customer_payments_maximum = "",
                        customer_total_spent_minimum = "",
                        customer_total_spent_maximum = "",
                        customer_average_spent_minimum = "",
                        customer_average_spent_maximum = "",
                        limit = 1000,
                        offset = 0)
        endpoint = "get_customers"
        parameters = { "customer_name" => customer_name,
                       "customer_mobile_number" => customer_mobile_number,
                       "customer_email" => customer_email,
                       "customer_first_payment_from" => customer_first_payment_from,
                       "customer_first_payment_to" => customer_first_payment_to,
                       "customer_last_payment_from" => customer_last_payment_from,
                       "customer_last_payment_to" => customer_last_payment_to,
                       "customer_payments_minimum" => customer_payments_minimum,
                       "customer_payments_maximum" => customer_payments_maximum,
                       "customer_total_spent_minimum" => customer_total_spent_minimum,
                       "customer_total_spent_maximum" => customer_total_spent_maximum,
                       "customer_average_spent_minimum" => customer_average_spent_minimum,
                       "customer_average_spent_maximum" => customer_average_spent_maximum,
                       "limit" => limit,
                       "offset" => offset }
        execute(endpoint, parameters)
      end

      ##
      # Authorize card transaction
      #
      # {Full docs - authorize_card_transaction}[http://developer.lipisha.com/index.php/app/launch/api_authorize_card_transaction]
      #
      # ==== Attributes
      #
      # * +account_number+
      # * +card_number+
      # * +address1+
      # * +address2+
      # * +expiry+
      # * +name+
      # * +country+
      # * +state+
      # * +zip+
      # * +security_code+
      # * +amount+
      # * +currency+
      #
      #
      def authorize_card_transaction(account_number,
                                     card_number,
                                     address1,
                                     address2,
                                     expiry,
                                     name,
                                     country,
                                     state,
                                     zip,
                                     security_code,
                                     amount,
                                     currency)
        endpoint = "authorize_card_transaction"
        parameters = { "account_number" => account_number,
                       "card_number" => card_number,
                       "address1" => address1,
                       "address2" => address2,
                       "expiry" => expiry,
                       "name" => name,
                       "country" => country,
                       "state" => state,
                       "zip" => zip,
                       "security_code" => security_code,
                       "amount" => amount,
                       "currency" => currency }
        execute(endpoint, parameters)
      end

      ##
      # Reverse card transaction
      #
      # {Full docs - reverse_card_transaction}[http://developer.lipisha.com/index.php/app/launch/api_reverse_card_transaction]
      #
      # ==== Attributes
      #
      # * +transaction_index+
      # * +transaction_reference+
      #
      #
      def reverse_card_transaction(transaction_index, transaction_reference)
        endpoint = "reverse_card_transaction"
        parameters = { "transaction_index" => transaction_index,
                       "transaction_reference" => transaction_reference }
        execute(endpoint, parameters)
      end

      ##
      # Complete card transaction
      #
      # {Full docs - complete_card_transaction}[http://developer.lipisha.com/index.php/app/launch/api_complete_card_transaction]
      #
      # ==== Attributes
      #
      # * +transaction_index+
      # * +transaction_reference+
      #
      #
      def complete_card_transaction(transaction_index, transaction_reference)
        endpoint = "complete_card_transaction"
        parameters = { "transaction_index" => transaction_index,
                       "transaction_reference" => transaction_reference }
        execute(endpoint, parameters)
      end

      ##
      # Void card transaction
      #
      # {Full docs - void_card_transaction}[http://developer.lipisha.com/index.php/app/launch/api_void_card_transaction]
      #
      # ==== Attributes
      #
      # * +transaction_index+
      # * +transaction_reference+
      #
      #
      def void_card_transaction(transaction_index, transaction_reference)
        endpoint = "void_card_transaction"
        parameters = { "transaction_index" => transaction_index,
                       "transaction_reference" => transaction_reference }
        execute(endpoint, parameters)
      end

      ##
      # Request settlement
      #
      # {Full docs - request_settlement}[http://developer.lipisha.com/index.php/app/launch/api_request_settlement]
      #
      # ==== Attributes
      #
      # * +account_number+
      # * +amount+
      #
      #
      def request_settlement(account_number, amount)
        endpoint = "request_settlement"
        parameters = { "account_number" => account_number, "amount" => amount }
        execute(endpoint, parameters)
      end
    end
  end
end
