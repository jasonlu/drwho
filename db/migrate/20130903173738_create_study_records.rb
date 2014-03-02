class CreateStudyRecords < ActiveRecord::Migration
  def change
    create_table :study_records do |t|
      t.integer :user_id
      t.integer :course_item_id
      t.string :content
      t.integer :study_id
      t.integer :course_id

      t.timestamps
    end
  end
end
