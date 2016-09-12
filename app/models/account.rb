# Account: Bank Account for a user
class Account < ActiveRecord::Base
  belongs_to :user
  has_many :bills
end
