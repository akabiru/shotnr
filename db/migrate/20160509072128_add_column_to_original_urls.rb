class AddColumnToOriginalUrls < ActiveRecord::Migration
  def change
    add_column :original_urls, :clicks, :integer, default: 0
  end
end
