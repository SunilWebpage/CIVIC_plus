module ApplicationHelper
  def safe_href(url, fallback = nil)
    SafeUrl.normalize(url) || fallback
  end

  def external_href?(url)
    SafeUrl.external?(url)
  end
end
