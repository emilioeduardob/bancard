module Bancard
  class Confirmation < Struct.new(:amount, :confirmed, :error, :transaction_id, :authorization_number, :currency, :response_text, keyword_init: true)
  end
end