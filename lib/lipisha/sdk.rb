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
        return @json.to_s
      end
    end
    ## 
    # This class defines API bindings for lipisha payments.
    # Each methods responds with an APIResponse object which
    # may be introspected for the status of the call.

    class LipishaAPI


      LIVE_API_BASE_URL = "https://www.lipisha.com/payments/accounts/index.php/v2/api/"
      SANDBOX_API_BASE_URL = "http://developer.lipisha.com/index.php/v2/api/"

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
      def initialize(api_key, api_signature, environment="LIVE")
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
          raise "`environment` must be either LIVE or TEST"
        end
      end

      def execute(api_endpoint, api_parameters)
        api_url = @api_base + api_endpoint
        uri = URI.parse(api_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme=="https")
        request = Net::HTTP::Post.new(uri.request_uri)
        # Set api key and signature
        api_parameters["api_key"] = @api_key
        api_parameters["api_signature"] = @api_signature
        request.set_form_data(api_parameters)
        response = http.request(request)
        response_map = JSON.parse(response.body)
        api_response = APIResponse.new(response_map["status"]["status"],
                                      response_map["status"]["status_code"],
                                      response_map["status"]["status_description"],
                                      response_map["content"],
                                      response_map)
        return api_response
      end
      
      ##
      # Gets available balance in Lipisha main account
      #
      def get_balance()
        endpoint = "get_balance"
        parameters = {}
        return execute(endpoint, parameters)
      end

      ##
      # Gets available balance in float account
      #
      # ==== Attributes
      #
      # * +account_number+ - float account number to look up
      #
      def get_float(account_number)
        endpoint = "get_float"
        parameters = {"account_number" => account_number}
        return execute(endpoint, parameters)
      end

    end
  end
end
