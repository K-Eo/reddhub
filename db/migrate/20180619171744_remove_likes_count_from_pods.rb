class RemoveLikesCountFromPods < ActiveRecord::Migration[5.2]
  def change
    remove_column :pods, :likes_count, :integer, default: 0, null: false
  end
end
