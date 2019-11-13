class AddTitleAndCategoryToMicropost < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :title, :string
    add_column :microposts, :category, :string
  end
end
