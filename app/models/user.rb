class User < ActiveRecord::Base
  has_many :original_urls

  def self.from_omni_auth(auth_hash)
    user = find_or_create_by(
      uid: auth_hash["uid"],
      provider: auth_hash["provider"]
    )
    user.name = auth_hash["info"]["name"]
    user.image_url = auth_hash["info"]["image"]
    user.url = auth_hash["info"]["urls"]["Twitter"]
    user.save
    user
  end
end
