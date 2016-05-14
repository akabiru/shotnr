module ShortUrlsHelper
  def full_short_url(s)
    "#{root_url}#{s.vanity_string}"
  end
end
