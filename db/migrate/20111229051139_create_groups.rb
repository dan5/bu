class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :owner_user_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
