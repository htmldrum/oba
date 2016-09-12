# Address: Physical address for the user
class Address < ActiveRecord::Base
  belongs_to :user
end
