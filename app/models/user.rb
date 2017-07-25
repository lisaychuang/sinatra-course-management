class User < ActiveRecord::Base
  has_secure_password
  validates :full_name, :username, :email, presence: true
  
end