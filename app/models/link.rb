class Link < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :actual
  after_create :generate_vanity_string

  ALPHABETS = "x6QW9Js5T7MHCyVj0uRIkrYaLFlSh4b3fpZANz1o8wqKtX2d"\
  "OBnvGUcgiEDmeP-_".split(//)

  def increment_clicks
    self.clicks += 1
    save
  end

  def active?
    active
  end

  def inactive?
    !active
  end

  def ours?
    [
      "http://www.shotnr.com",
      "http://shotnr.com",
      "https://shotnr.herokuapp.com",
      "https://shotnr-staging.herokuapp.com"
    ].include? actual
  end

  def generate_vanity_string
    return if vanity_string.present?
    shotlink = ""
    link_id = id
    base = ALPHABETS.size
    while link_id > 0
      shotlink << ALPHABETS[link_id.modulo(base)]
      link_id /= base
    end
    self.vanity_string = shotlink.reverse
    save
  end
end
