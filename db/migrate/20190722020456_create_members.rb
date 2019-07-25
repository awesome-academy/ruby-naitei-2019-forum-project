class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.integer :sub_forum_id
      t.integer :user_id
      t.integer :user_type

      t.timestamps
    end
    add_index :members, :sub_forum_id
    add_index :members, :user_id
    add_index :members, :user_type
    add_index :members, [:sub_forum_id,:user_id], unique: true
  end
end
