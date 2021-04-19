module Bancard
  class TransactionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def process_id
      if transaction = Transaction.find(params[:id])

        process_id = Bancard::SingleBuy.new(
          success_url: transaction.success_url,
          amount: transaction.amount,
          description: transaction.description,
          shop_process_id: transaction.id
        ).get_process_id

        render json: { process_id: process_id }
      else
        render json: { error: "Transaction not found"}, status: 500
      end
    end

    # Returns the commision value for a given transaction amount
    def commission
      result = Bancard::Commission.new(amount: transaction.amount).run
      render json: result
    end

    def confirm
      if confirmation.valid_request?
        response = confirmation.verify_payment
        @transaction = Bancard::Transaction.find(response.transaction_id)
        if response.confirmed
          @transaction.update(status: :success, authorization_number: response[:authorization_number])
          @transaction.payable.confirm_vpos!
        else
          @transaction.update(status: :failed)
        end
        head :ok
      else
        head 401
      end
    end

    # Bancard visits this page if the payment failed or not
    def return_url
      @transaction = Bancard::Transaction.find(params[:id])
      if params[:status] == "payment_fail"
        flash[:error] = "Error al recibir el pago"
        redirect_to @transaction.failure_url
      else
        flash[:notice] = "Pagado exitosamente"
        redirect_to @transaction.success_url
      end
    end

    private

    def confirmation
      @confirmation ||= Bancard::HandleConfirmation.new(params)
    end
  end
end