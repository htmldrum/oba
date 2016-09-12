# Admin: Represents an administrative user
class Admin < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # :confirmable, :timeoutable, :omniauthable, :lockable
end
