require "http"

module Bancard
  class Commission
    URL = "#{Bancard::Base::BASE_HOST}/vpos/api/0.3/commissions"

    attr_reader :amount, :currency

    # ban = Bancard::Comission.new()
    def initialize(amount:, currency: "PYG")
      @amount = amount
      @currency = currency
    end

    def run
      response = HTTP.post(URL, json: payload).parse
      if response["status"] == "success"
        return response["commission"]
      end
      Rails.logger.info "Error al obtener token: #{response.inspect}"
      false
    end

    private

    def payload
      {
        public_key: Bancard::Base::PUBLIC_KEY,
        operation: {
          token: generar_token,
          items: [
            {
              amount: formatted_amount,
              currency: currency
            }
          ]
        }
      }
    end

    def formatted_amount
      sprintf("%.2f", amount)
    end

    def generar_token
      Digest::MD5.hexdigest [Bancard::Base::PRIVATE_KEY, "commission", formatted_amount].join
    end
  end
end