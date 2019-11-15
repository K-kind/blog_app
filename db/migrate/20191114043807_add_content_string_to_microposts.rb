class AddContentStringToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :content_string, :text
  end
end
