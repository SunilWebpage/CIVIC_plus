require "uri"

module SafeUrl
  module_function

  def normalize(url)
    value = url.to_s.strip
    return if value.empty?

    return value if relative_path?(value)

    uri = URI.parse(value)
    return unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    return if uri.host.blank?

    uri.to_s
  rescue URI::InvalidURIError
    nil
  end

  def external?(url)
    normalized = normalize(url)
    normalized.present? && normalized.start_with?("http://", "https://")
  end

  def relative_path?(value)
    value.start_with?("/") && !value.start_with?("//")
  end
end
