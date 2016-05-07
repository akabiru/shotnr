class OriginalUrl < ActiveRecord::Base
  attr_accessor :vanity_string
  has_one :short_url
  validates_presence_of :long_url

  def self.find_long_url(vanity_string)
    short_url_record = ShortUrl.find_by(vanity_string: vanity_string)
    if short_url_record
      OriginalUrl.find(short_url_record.original_url_id)
    else
      false
    end
  end

end
