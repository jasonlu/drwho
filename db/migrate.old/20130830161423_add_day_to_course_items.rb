class AddDayToCourseItems < ActiveRecord::Migration
  def change
    add_column :course_items, :day, :integer
  end
end
