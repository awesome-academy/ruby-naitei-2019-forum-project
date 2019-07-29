class CreatePostInteractions < ActiveRecord::Migration[5.1]
  def change
    create_table :post_interactions do |t|
      t.integer :member_id
      t.integer :post_id
      t.integer :vote
      t.integer :interaction_type

      t.timestamps
    end
  end
end
