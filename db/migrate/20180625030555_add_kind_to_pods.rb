class AddKindToPods < ActiveRecord::Migration[5.2]
  def change
    add_column :pods, :kind, :integer, default: 0, null: false
  end
end
