class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.text :content
      t.integer :weight
      t.string :link
      t.integer :counter
      t.integer :location

      t.timestamps
    end
  end
end
