class ChangeContentTypeToPods < ActiveRecord::Migration[5.2]
  def up
    change_column :pods, :content, :text
  end

  def down
    change_column :pods, :content, :string
  end
end
