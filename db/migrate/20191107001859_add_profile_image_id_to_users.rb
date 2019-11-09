class AddProfileImageIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile_image_id, :string
  end
end
