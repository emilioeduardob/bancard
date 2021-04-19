module Bancard
  class HandleConfirmation
    attr_reader :params, :amount, :shop_process_id, :currency

    def initialize(_params)
      @params = _params.fetch(:operation, {})
      @shop_process_id = params[:shop_process_id]
      @amount = params[:amount]
      @currency = params[:currency]
    end

    def valid_request?
      params[:token] == confirmation_token
    end

    def verify_payment
      if valid_request?
        response = {
          transaction_id: shop_process_id,
          currency: currency,
          amount: amount
        }
        if params[:response_code] == "00"
          response.merge!(confirmed: true,
            authorization_number: params[:authorization_number],
            response_text: params[:response_description]
          )
        else
          response.merge!(
            confirmed: false,
            error: build_error(params[:response_code], params[:extended_response_description])
          )
        end
        Confirmation.new(response)
      else
        Confirmation.new(error: "Invalid request")
      end
    end

    private

    def build_error(code, extended_msg)
      message = case code
        when "05" then "Tarjeta inhabilitada"
        when "03" then "Transacción denegada"
        when "12" then "Transacción Inválida"
        when "15" then "Tarjeta Inválida"
        when "51" then "Fondos insuficientes"
        else "Error desconocido"
      end
      message = [message, extended_msg].compact.join(": ")
      message
    end

    def formatted_amount
      sprintf("%.2f", amount)
    end

    def confirmation_token
      Digest::MD5.hexdigest [Bancard::Base::PRIVATE_KEY, shop_process_id, "confirm", formatted_amount, currency].join
    end
  end
end