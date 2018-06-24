class AddDescriptionToPods < ActiveRecord::Migration[5.2]
  def change
    add_column :pods, :description, :text
  end
end
