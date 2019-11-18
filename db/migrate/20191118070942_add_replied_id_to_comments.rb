class AddRepliedIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :replied_id, :integer
  end
end
