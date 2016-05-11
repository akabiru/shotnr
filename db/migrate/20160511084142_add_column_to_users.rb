class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_clicks, :integer, default: 0
  end
end
