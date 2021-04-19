require "http"

module Bancard
  class Cards::List
    URL = "#{Bancard::Base::BASE_HOST}/vpos/api/0.3/users/:user_id/cards"

    attr_reader :user_id

    # ban = Bancard::SingleBuy.new(success_url: "http://localhost:3000/success", card_id: 100000, user_cell_phone: 6, description: "Prueba")
    def initialize(user_id:)
      @user_id = user_id
    end

    def run
      response = HTTP.post(URL.gsub(":user_id", user_id.to_s), json: process_id_payload).parse
      if response["status"] == "success"
        return response["cards"]
      end
      Rails.logger.info "Error al obtener token: #{response.inspect}"
      []
    end

    private

    def process_id_payload
      {
        public_key: Bancard::Base::PUBLIC_KEY,
        operation: {
          token: generar_token,
        }
      }
    end

    def generar_token
      Digest::MD5.hexdigest [Bancard::Base::PRIVATE_KEY, user_id, "request_user_cards"].join
    end
  end
end