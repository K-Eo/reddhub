class AddReactionsCountToPods < ActiveRecord::Migration[5.2]
  def change
    add_column :pods, :reactions_count, :integer, default: 0, null: false
  end
end
