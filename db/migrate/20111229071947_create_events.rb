class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :group_id
      t.string :title
      t.string :place
      t.string :address
      t.integer :limit
      t.datetime :started_at
      t.datetime :ended_at
      t.text :description
      t.boolean :ended, :default => false

      t.timestamps
    end
  end
end
