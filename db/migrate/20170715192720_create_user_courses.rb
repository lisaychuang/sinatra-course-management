class CreateUserCourses < ActiveRecord::Migration
  def change
    create_table :user_courses do |t|
      t.integer :confirmation, :default => 0
      t.string :notes
      t.integer :user_id
      t.integer :course_id
    end
  end
end
