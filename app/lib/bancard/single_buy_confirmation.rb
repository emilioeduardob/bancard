require "http"

module Bancard
  class SingleBuyConfirmation
    API_URL = "#{Bancard::Base::BASE_HOST}/vpos/api/0.3/single_buy/confirmations"

    attr_reader :shop_process_id

    # ban = Bancard::SingleBuyConfirmation.new(shop_process_id: 6)
    def initialize(shop_process_id:)
      @shop_process_id = shop_process_id
    end

    def run
      response = HTTP.post(API_URL, json: process_id_payload).parse
      if response["status"] == "success"
        return {
          success: true,
          confirmation: response["confirmation"]
        }
      end
      Rails.logger.info "Error al hacer #{response.inspect}"
      {
        success: false
      }
    end

    private

    def process_id_payload
      {
        public_key: Bancard::Base::PUBLIC_KEY,
        operation: {
          token: generar_token,
          shop_process_id: shop_process_id
        }
      }
    end

    def generar_token
      Digest::MD5.hexdigest [Bancard::Base::PRIVATE_KEY, shop_process_id, "get_confirmation"].join
    end
  end
end