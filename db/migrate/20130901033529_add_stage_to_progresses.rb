class AddStageToProgresses < ActiveRecord::Migration
  def change
    add_column :progresses, :stage, :integer
  end
end
