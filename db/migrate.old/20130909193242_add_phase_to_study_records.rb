class AddPhaseToStudyRecords < ActiveRecord::Migration
  def change
    add_column :progresses, :phase, :integer
    add_column :study_records, :phase, :integer
  end
end
