class CreateBancardTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :bancard_transactions do |t|
      t.integer :status
      t.decimal :amount
      t.string :authorization_number
      t.string :error_message
      t.string :payable_type
      t.integer :payable_id
      t.string :success_url
      t.string :failure_url
      t.string :description

      t.timestamps
    end
  end
end
