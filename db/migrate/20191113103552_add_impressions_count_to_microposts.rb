class AddImpressionsCountToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :impressions_count, :integer
  end
end
