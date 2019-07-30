class AddDefaultValueToUserTypeInMember < ActiveRecord::Migration[5.1]
  def change
    change_column :members, :user_type, :integer, default: Settings.member_forum
  end
end
