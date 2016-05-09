class ShortUrl < ActiveRecord::Base
  belongs_to :original_url
  belongs_to :user

  validates_presence_of :original_url_id
  validates :vanity_string, presence: true

  ALPHABETS = 'x6QW9Js5T7MHCyVj0uRIkrYaLFlSh4b3fpZANz1o8wqKtX2d'\
  'OBnvGUcgiEDmeP-_'.split(//)

  def generate_short_url
    self.vanity_string = encode_original_url_id
    save
  end

  def encode_original_url_id
    short_url = ''
    original_url_id_ = original_url_id
    base = ALPHABETS.size
    while original_url_id_ > 0
      short_url << ALPHABETS[original_url_id_.modulo(base)]
      original_url_id_ /= base
    end
    short_url.reverse
  end
end
