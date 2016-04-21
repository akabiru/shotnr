class AddColumnToUrls < ActiveRecord::Migration
  def change
    add_column :urls , :hits, :integer, default: 0
  end
end
