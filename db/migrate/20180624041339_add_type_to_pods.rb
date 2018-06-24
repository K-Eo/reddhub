class AddTypeToPods < ActiveRecord::Migration[5.2]
  def change
    add_column :pods, :type, :string
  end
end
