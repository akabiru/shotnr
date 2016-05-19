module LinksHelper
  def shotlink(link)
    "#{root_url.sub(/www./, '')}#{link.vanity_string}"
  end

  def full_shotlink(link)
    "#{root_url}#{link.vanity_string}"
  end
end
