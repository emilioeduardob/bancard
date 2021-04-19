require "http"

module Bancard
  class SingleBuyRollback
    API_URL = "#{Bancard::Base::BASE_HOST}/vpos/api/0.3/single_buy/rollback"

    attr_reader :shop_process_id

    # ban = Bancard::SingleBuyRollback.new(shop_process_id: 6)
    def initialize(shop_process_id:)
      @shop_process_id = shop_process_id
    end

    def run
      response = HTTP.post(API_URL, json: process_id_payload).parse
      if response["status"] == "success"
        return {
          success: true
        }
      end
      Rails.logger.info "Error al hacer rollback #{response.inspect}"
      {
        success: false,
        error: response["messages"].map { |msg| [msg["key"], msg["dsc"]].join(": ") }.join(", ")
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

    def formatted_amount
      sprintf("%.2f", 0)
    end

    def generar_token
      Digest::MD5.hexdigest [Bancard::Base::PRIVATE_KEY, shop_process_id, "rollback", formatted_amount].join
    end
  end
end