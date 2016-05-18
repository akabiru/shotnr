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
end
