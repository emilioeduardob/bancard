require "http"

module Bancard
  class SingleBuy
    SINGLE_BUY_URL = "#{Bancard::Base::BASE_HOST}/vpos/api/0.3/single_buy"

    attr_reader :success_url, :amount, :currency, :shop_process_id, :description

    # ban = Bancard::SingleBuy.new(success_url: "http://localhost:3000/success", amount: 100000, shop_process_id: 6, description: "Prueba")
    def initialize(success_url:, amount:, shop_process_id:, description:, currency: "PYG")
      @success_url = success_url
      @amount = amount
      @description = description
      @currency = currency
      @shop_process_id = shop_process_id
    end

    def get_process_id
      response = HTTP.post(SINGLE_BUY_URL, json: process_id_payload).parse
      if response["status"] == "success"
        return response["process_id"]
      end
      Rails.logger.info "Error al obtener token: #{response.inspect}"
      false
    end

    private

    def process_id_payload
      {
        public_key: Bancard::Base::PUBLIC_KEY,
        operation: {
          token: generar_token,
          shop_process_id: shop_process_id,
          amount: formatted_amount,
          currency: currency,
          description: description,
          cancel_url: success_url, # igual al return_url porque ahora funciona asi bancard
          return_url: success_url
        }
      }
    end

    def formatted_amount
      sprintf("%.2f", amount)
    end

    def generar_token
      Digest::MD5.hexdigest [Bancard::Base::PRIVATE_KEY, shop_process_id, formatted_amount, currency].join
    end
  end
end