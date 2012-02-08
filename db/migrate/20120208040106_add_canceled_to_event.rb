class AddCanceledToEvent < ActiveRecord::Migration
  def change
    add_column :events, :canceled, :boolean

  end
end
