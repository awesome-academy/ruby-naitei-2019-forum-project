class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :member_id

      t.timestamps
    end
  end
end
