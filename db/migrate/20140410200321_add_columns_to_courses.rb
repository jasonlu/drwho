class AddColumnsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :uuid, :string
  end
end
