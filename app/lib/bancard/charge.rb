require "http"

module Bancard
  class Charge
    URL = "#{Bancard::Base::BASE_HOST}/vpos/api/0.3/charge"

    attr_reader :amount, :currency, :number_of_payments,
      :shop_process_id, :alias_token, :description, :additional_data, :invoice_data

    # ban = Bancard::Charge.new()
    def initialize(number_of_payments:, amount:, shop_process_id:, additional_data:,
      description:, alias_token:, invoice_data: nil, currency: "PYG")
      @number_of_payments = number_of_payments
      @amount = amount
      @description = description
      @invoice_data = invoice_data
      @additional_data = additional_data
      @currency = currency
      @shop_process_id = shop_process_id
      @alias_token = alias_token
    end

    def run
      HTTP.post(URL, json: payload).parse
    end

    private

    def payload
      {
        public_key: Bancard::Base::PUBLIC_KEY,
        operation: {
          token: generar_token,
          shop_process_id: shop_process_id,
          amount: formatted_amount,
          additional_data: additional_data,
          currency: currency,
          description: description,
          number_of_payments: number_of_payments,
          alias_token: alias_token,
          commission: invoice_data
        }
      }
    end

    def formatted_amount
      sprintf("%.2f", amount)
    end

    def generar_token
      Digest::MD5.hexdigest [Bancard::Base::PRIVATE_KEY, shop_process_id, "charge",
        formatted_amount, currency, alias_token].join
    end
  end
end