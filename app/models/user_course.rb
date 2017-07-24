class UserCourse < ActiveRecord::Base
    belongs_to :user
    belongs_to :course

    validates :notes, presence: true
end