class AddFollowingCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :following_count, :integer, default: 0, null: false
  end
end
