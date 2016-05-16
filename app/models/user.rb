class User < ActiveRecord::Base
  has_many :short_urls
  has_many :original_urls, through: :short_urls
  def increment_total_clicks
    self.total_clicks += 1
    save
  end

  def trending_shotlink
    max_shotlink = { clicks: 0 }
    max_shotlink[:original_url] = short_urls.first.original_url
    short_urls.each do |s|
      if s.original_url.clicks > max_shotlink[:clicks]
        max_shotlink[:clicks] = s.original_url.clicks
        max_shotlink[:original_url] = s.original_url
      end
    end
    max_shotlink
  end

  def self.from_omni_auth(auth_hash)
    user = find_or_create_by(
      uid: auth_hash["uid"],
      provider: auth_hash["provider"]
    ) do |user|
      user.name = auth_hash["info"]["name"]
      user.image_url = auth_hash["info"]["image"]
      user.url = auth_hash["info"]["urls"]["Twitter"]
      user.save!
    end
    user
  end
end
