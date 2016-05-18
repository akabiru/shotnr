class ModifyUsers < ActiveRecord::Migration
  def change
    remove_column :users, :total_clicks, :integer, default: 0
    remove_column :users, :url, :string
  end
end
