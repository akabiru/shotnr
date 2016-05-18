class User < ActiveRecord::Base
  has_many :links

  def self.from_omni_auth(auth_hash)
    user = find_or_create_by(
      uid: auth_hash["uid"],
      provider: auth_hash["provider"]
    ) do |user|
      user.name = auth_hash["info"]["name"]
      user.image_url = auth_hash["info"]["image"]
      user.save
    end
    user
  end

  def self.top_users
    ActiveRecord::Base.connection.execute(
      "SELECT users.name, users.image_url, sum(links.clicks) as total_clicks" \
      " FROM links INNER JOIN users ON links.user_id = users.id" \
      " GROUP BY users.id ORDER BY total_clicks DESC LIMIT 10"
    )
  end
end
