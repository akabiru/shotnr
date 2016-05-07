module OriginalUrlsHelper
  def shortened_url(original_url)
    "#{root_url}#{original_url.short_url.vanity_string}"
  end
end
