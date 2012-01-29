class AddImageUrlToEvent < ActiveRecord::Migration
  def change
    add_column :events, :image_url, :string
  end
end
