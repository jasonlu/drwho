class AddUuidToStudies < ActiveRecord::Migration
  def change
    add_column :studies, :uuid, :string
  end
end
