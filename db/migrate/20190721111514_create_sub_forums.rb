class CreateSubForums < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_forums do |t|
      t.string :name
      t.text :description
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :sub_forums, :name, unique: true
  end
end
