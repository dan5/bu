class AddSummaryToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :summary, :string
  end
end
