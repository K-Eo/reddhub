class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.references :reactable, polymorphic: true

      t.timestamps
    end
  end
end
