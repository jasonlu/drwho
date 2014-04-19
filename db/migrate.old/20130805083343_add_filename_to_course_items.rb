class AddFilenameToCourseItems < ActiveRecord::Migration
  def change
    add_column :course_items, :filename, :string
  end
end
