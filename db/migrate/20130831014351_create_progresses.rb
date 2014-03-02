class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.integer :study_id
      t.integer :course_id
      t.integer :course_item_id
      t.integer :user_id
      t.integer :day
      t.integer :score

      t.timestamps

    end
  end
end
