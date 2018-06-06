class AddPendingDeleteToPods < ActiveRecord::Migration[5.2]
  def change
    add_column :pods, :pending_delete, :boolean, default: false
  end
end
