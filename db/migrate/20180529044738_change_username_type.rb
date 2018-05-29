class ChangeUsernameType < ActiveRecord::Migration[5.2]
  def up
    enable_extension "citext"

    change_table :users do |t|
      t.change :username, :citext
    end

    add_index :users, :username, unique: true
  end

  def down
    change_table :users do |t|
      t.change :username, :string
    end

    remove_index :users, :username
  end
end
