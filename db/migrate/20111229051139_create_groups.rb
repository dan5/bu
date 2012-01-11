class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :owner_user_id
      t.string :name
      t.text :description
      t.integer :permission, :default => 0 # 0:public / 1:need invitation / 2:secret

      t.timestamps
    end
  end
end
