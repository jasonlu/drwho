class ChangeColumnsInAds < ActiveRecord::Migration
  def change
    change_column :ads, :location, :string
  end
end
