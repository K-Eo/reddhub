class DropStories < ActiveRecord::Migration[5.2]
  def up
    drop_table :stories do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end

  def down
    create_table :stories do |t|
      t.string :title
      t.text :content

      t.timestamps
    end

    add_reference :stories, :user, foreign_key: true

    add_column :stories, :state, :string
    add_index :stories, :state

    add_column :stories, :published_at, :datetime
    add_column :stories, :subtitle, :string
  end
end
