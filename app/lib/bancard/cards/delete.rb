require "http"

module Bancard
  class Cards::Delete
    URL = "#{Bancard::Base::BASE_HOST}/vpos/api/0.3/users/:user_id/cards"

    attr_reader :alias_token, :user_id

    # ban = Bancard::SingleBuy.new(alias_token: "http://localhost:3000/success", card_id: 100000, user_cell_phone: 6, description: "Prueba")
    def initialize(alias_token:, user_id:)
      @alias_token = alias_token
      @user_id = user_id
    end

    def run
      response = HTTP.delete(URL.sub(":user_id", user_id.to_s), json: process_id_payload).parse
      if response["status"] == "success"
        return true
      end
      Rails.logger.info "Error al borrar tarjeta: #{response.inspect}"
      false
    end

    private

    def process_id_payload
      {
        public_key: Bancard::Base::PUBLIC_KEY,
        operation: {
          token: generar_token,
          alias_token: alias_token
        }
      }
    end

    def generar_token
      Digest::MD5.hexdigest [Bancard::Base::PRIVATE_KEY, "delete_card", user_id, alias_token].join
    end
  end
end