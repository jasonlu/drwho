class CreateSelfLearnings < ActiveRecord::Migration
  def change
    create_table :self_learnings do |t|
      t.integer :user_id
      t.string :original
      t.string :trsnslation
      t.string :word_type

      t.timestamps
    end
  end
end
