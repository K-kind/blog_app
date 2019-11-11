class AddPostImageIdToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :post_image_id, :string
  end
end
