class AddTitleToPods < ActiveRecord::Migration[5.2]
  def change
    add_column :pods, :title, :text
  end
end
