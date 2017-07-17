class User < ActiveRecord::Base
  has_many :courses_teaching, class_name: "Course", primary_key: "instructor_id"
#   has_many :courses_studying, class_name: "Course", through: ''
end