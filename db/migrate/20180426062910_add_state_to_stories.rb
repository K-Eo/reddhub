class AddStateToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :state, :string
    add_index :stories, :state
  end
end
