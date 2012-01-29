class AddImageUrlToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :image_url, :string
  end
end
