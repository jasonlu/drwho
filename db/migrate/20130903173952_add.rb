class Add < ActiveRecord::Migration
  def change
    add_column :study_records, :stage, :integer
  end
end
