class OriginalUrl < ActiveRecord::Base
  attr_accessor :vanity_string
  has_one :short_url, dependent: :destroy
  validates_presence_of :long_url

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

  def this_one?
    [
      'https://www.shotnr.com',
      'http://shotnr.com',
      'https:shotnr.herokuapp.com',
      'https:shotnr-staging.herokuapp.com'
    ].include? long_url
  end

  def self.find_long_url(vanity_string)
    short_url_record = ShortUrl.find_by(vanity_string: vanity_string)
    if short_url_record
      OriginalUrl.find(short_url_record.original_url_id)
    else
      false
    end
  end
end
