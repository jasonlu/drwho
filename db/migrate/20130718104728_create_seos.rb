class CreateSeos < ActiveRecord::Migration
  def change
    create_table :seos do |t|

      t.integer :obj_id
      t.text :description
      t.text :keyword
      t.text :title
      t.text :image

      t.timestamps
    end
  end
end
