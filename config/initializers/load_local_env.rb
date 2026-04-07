env_file = Rails.root.join(".env.local")

if env_file.exist?
  env_file.each_line do |line|
    entry = line.strip
    next if entry.empty? || entry.start_with?("#") || !entry.include?("=")

    key, value = entry.split("=", 2)
    ENV[key] ||= value.to_s.strip
  end
end
