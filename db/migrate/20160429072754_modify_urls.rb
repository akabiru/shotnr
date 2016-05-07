class ModifyUrls < ActiveRecord::Migration
  def change
    rename_table :urls, :original_urls
    remove_column :original_urls, :short_url, :string
    remove_column :original_urls, :hits, :integer, default: 0
  end
end
