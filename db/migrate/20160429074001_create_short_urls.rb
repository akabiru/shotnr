class CreateShortUrls < ActiveRecord::Migration
  def change
    create_table :short_urls do |t|
      t.string :vanity_string
      t.integer :original_url_id
      t.integer :user_id
      t.timestamps null: false
    end

    add_index :short_urls, :vanity_string, unique: true
  end
end
