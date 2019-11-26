class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :social_image_url, :string
  end

  def down
    remove_column :users, :uid
    remove_column :users, :provider
    remove_column :users, :social_image_url
  end
end
