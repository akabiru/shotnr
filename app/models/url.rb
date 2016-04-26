class Url < ActiveRecord::Base

  after_create :generate_short_url

  ALPHABETS = "x6QW9Js5T7MHCyVj0uRIkrYaLFlSh4b3fpZANz1o8wqKtX2d"\
  "OBnvGUcgiEDmeP/-".split(//)

  def increment_hits
    self.hits += 1
    save
  end

  def generate_short_url
    self.short_url = base_encode
    save
  end

  def base_encode
    short_url = ''
    url_id = self.id
    base = ALPHABETS.size
    while url_id > 0
      short_url << ALPHABETS[url_id.modulo(base)]
      url_id /= base
    end
    short_url.reverse
  end

  def self.base_decode(url_string)
    i = 0
    base = ALPHABETS.size
    url_string.each_char { |c| i = i * base + ALPHABETS.index(c) }
    Url.find(i)
  end
end
