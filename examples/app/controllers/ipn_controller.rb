class IpnController < ApplicationController

  API_KEY = 'e0558566d0381997ba5c4480176d19ce'
  #ENV["LIPISHA_API_KEY"]
  API_SIGNATURE = 'RMhSnT/KlGQiNL2/5D2tH1a6ovf8lpqhExIxOfcjvtuqtpK8n6gPgmowrFoZtFGhj7USsnTIe/7F48tgxq/HrwQ5siphD8u58HOKzQMtzENvaU1+K36RWvVFmRSyME9UeHAUx/GxUGXS3ddE0n9/i3THhb4JVZsn88K4bQ2vvpM='
  #ENV["LIPISHA_API_SIGNATURE"]
  API_VERSION = "1.3.0"
  ACTION_INITIATE = "Initiate"
  ACTION_ACKNOWLEDGE = "Acknowledge"
  ACTION_RECEIPT = "Receipt"
  STATUS_SUCCESS = "Success"
  STATUS_SUCCESS_CODE = "001"

  def post
    if ((params["api_key"]==API_KEY and params["api_signature"]==API_SIGNATURE))
      api_type = params["api_type"]
      Rails.logger.debug("Request data #{params}")
      if (api_type==ACTION_INITIATE)
        # Acknowledge API CALL
        #
        # Perform processing and storage here if required

        # Respond to Lipisha to confirm transaction has been received.
        # Lipisha would then acknowledge this request - see below
        response = {
          "api_key" => API_KEY,
          "api_signature" => API_SIGNATURE,
          "api_version" => API_VERSION,
          "api_type" => ACTION_RECEIPT,
          "transaction_reference" => params["transaction_reference"],
          "transaction_status_code" => STATUS_SUCCESS_CODE,
          "transaction_status" => STATUS_SUCCESS,
          "transaction_status_description" => "Transaction received",
          "transaction_custom_sms" => "Payment received. Thank you."
        }
        render :json => response
      elsif (api_type=ACTION_ACKNOWLEDGE)
        # Lipisha acknowledges the transaction
        # At this point we can update our records confirming that the cash has actually been received.

        transaction_reference = params["transaction_reference"]
        transaction_status = params["transaction_status"]
        transaction_status_code = params["transaction_status_code"]
        transaction_status_description = params["transaction_status_description"]
        Rails.logger.debug("Received acknowledgemnt: TX: #{transaction_reference} | Status: #{transaction_status}")
        render :text => "OK"
      else
        render :text => "Invalid Request", :status => :bad_request
      end
    else
      Rails.logger.error("Invalid IPN Credentials")
      render :text => "Invalid Credentials", :status => :unauthorized
    end
  end

  skip_before_filter :verify_authenticity_token
end
