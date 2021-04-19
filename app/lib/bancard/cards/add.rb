require "http"

module Bancard
  class Cards::Add
    URL = "#{Bancard::Base::BASE_HOST}/vpos/api/0.3/cards/new"

    attr_reader :success_url, :card_id, :user_email, :user_cell_phone, :user_id

    # ban = Bancard::SingleBuy.new(success_url: "http://localhost:3000/success", card_id: 100000, user_cell_phone: 6, description: "Prueba")
    def initialize(success_url:, card_id:, user_id:, user_cell_phone:, user_email:)
      @success_url = success_url
      @card_id = card_id
      @user_id = user_id
      @user_email = user_email
      @user_cell_phone = user_cell_phone
    end

    def get_process_id
      response = HTTP.post(URL, json: process_id_payload).parse
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
          card_id: card_id,
          user_id: user_id,
          user_cell_phone: user_cell_phone,
          user_mail: user_email,
          return_url: success_url
        }
      }
    end

    def generar_token
      Digest::MD5.hexdigest [Bancard::Base::PRIVATE_KEY, card_id, user_id, "request_new_card"].join
    end
  end
end