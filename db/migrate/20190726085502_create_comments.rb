class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :post_id
      t.integer :parent_id
      t.integer :member_id
      t.string :content

      t.timestamps
    end
  end
end
