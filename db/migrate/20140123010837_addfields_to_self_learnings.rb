class AddfieldsToSelfLearnings < ActiveRecord::Migration
  def change
    add_column :self_learnings, :grouping_id, :string
    add_column :self_learnings, :serial, :string
  end
end
