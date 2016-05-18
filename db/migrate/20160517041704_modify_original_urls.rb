class ModifyOriginalUrls < ActiveRecord::Migration
  def change
    rename_table :original_urls, :links
    add_column :links, :vanity_string, :string
    add_column :links, :user_id, :integer
    rename_column :links, :long_url, :actual
  end
end
