class User < ActiveRecord::Base
  has_secure_password
  has_many :courses
  has_many :userCourses
  validates :full_name, :username, :email, presence: true
end