class RemoveTypeFromPods < ActiveRecord::Migration[5.2]
  def change
    remove_column :pods, :type, :string
  end
end
