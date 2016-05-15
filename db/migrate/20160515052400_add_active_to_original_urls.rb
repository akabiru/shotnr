class AddActiveToOriginalUrls < ActiveRecord::Migration
  def change
    add_column :original_urls, :active, :boolean, default: true
  end
end
