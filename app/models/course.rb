class Course < ActiveRecord::Base
  belongs_to :instructor, class_name: "User"
  validates :instructor, presence: true
end