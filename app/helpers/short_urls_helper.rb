module ShortUrlsHelper
  def full_short_url(s)
    "#{root_url}#{s.short_url.vanity_string}"
  end
end
