class CreateClickRecords < ActiveRecord::Migration
  def change
    create_table :click_records do |t|
      t.text :url
      t.string :from
      t.integer :ad_id
      t.text :referer

      t.timestamps
    end
  end
end