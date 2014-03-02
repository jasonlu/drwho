class AddNoteToUserOrders < ActiveRecord::Migration
  def change
    add_column :user_orders, :note, :text
  end
end
