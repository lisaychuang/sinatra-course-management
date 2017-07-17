class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :icon
      t.integer :level
      t.integer :instructor_id
    end
  end
end
