class AddDraftToMicroposts < ActiveRecord::Migration[6.0]
  def up
    add_column :microposts, :draft, :boolean, default: false
  end

  def down
    remove_column :microposts, :draft
  end
end
