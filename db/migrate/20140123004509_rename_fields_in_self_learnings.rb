class RenameFieldsInSelfLearnings < ActiveRecord::Migration
  def change
    rename_column :self_learnings, :trsnslation, :translation
    add_column :self_learnings, :order, :integer
  end
end
