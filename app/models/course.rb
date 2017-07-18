class Course < ActiveRecord::Base
  belongs_to :instructor, class_name: "User"
  validates :instructor, :name, :description, :level, presence: true
end