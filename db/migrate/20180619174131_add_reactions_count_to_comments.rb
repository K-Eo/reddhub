class AddReactionsCountToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :reactions_count, :integer, default: 0, null: false
  end
end
