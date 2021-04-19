module Bancard
  class Transaction < ApplicationRecord
    belongs_to :payable, polymorphic: true
    enum status: { pending: 0, success: 1, failed: 2 }
  end
end
