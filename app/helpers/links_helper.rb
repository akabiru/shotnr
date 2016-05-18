module LinksHelper
  def shotlink(link)
    "#{root_url}#{link.vanity_string}"
  end
end
