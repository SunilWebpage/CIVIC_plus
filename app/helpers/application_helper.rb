module ApplicationHelper
  def safe_href(url, fallback = nil)
    SafeUrl.normalize(url) || fallback
  end

  def pdf_href_for(record, fallback = nil)
    return fallback unless record
    return url_for(record.pdf_file) if record.respond_to?(:pdf_file) && record.pdf_file.attached?

    safe_href(record.try(:pdf_url), fallback)
  end

  def external_href?(url)
    SafeUrl.external?(url)
  end
end
