module ApplicationHelper
  def valid_url?(url)
    url.match?(/^(http)s?:\/\//)
  end
end
