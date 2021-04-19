module Bancard
  class Api::TokenPayments < Api::V1::JsonapiController
    def pagar
      success = PagarTramite.new(transaction, params[:alias_token], invoice_data: params[:invoice_data]).pay
      render json: { success: success, response: transaction.transactions.last }
    end

    private

    def transaction
      @transaction ||= Transaction.find(params[:id])
    end
  end
end