require "open-uri"
require "net/http"
require "nokogiri"
require "pathname"

require "i18n"
I18n.available_locales = [:en]

url = "https://en.wikipedia.org/wiki/Flags_of_Japanese_prefectures"
uri = URI.parse(url)

html = Net::HTTP.get_response(uri).body

doc = Nokogiri::HTML(html)

flags = []
doc.css(".gallerybox").each do |box|
  description = box.css(".gallerytext").text.strip
  data = {}
  case description
  when /^(?<name>\S+)( Prefecture)?$/
    data[:slug] = I18n.transliterate(Regexp.last_match[:name]).downcase
  when /^Symbol mark flag of (?<name>\S+)( Prefecture)?$/
    data[:slug] = I18n.transliterate(Regexp.last_match[:name]).downcase + "_sym"
  when /^(?<name>\S+)( Prefecture)? \(variant\)$/
    data[:slug] = I18n.transliterate(Regexp.last_match[:name]).downcase + "_var"
  when /^(?<name>\S+)( Prefecture)? \(\d+.*\)$/
    data[:slug] = I18n.transliterate(Regexp.last_match[:name]).downcase + "_old"
  end
  data[:name] = Regexp.last_match[:name]
  data[:reference_url] = "https://en.wikipedia.org" + box.css(".thumb a").attribute("href").to_s
  data[:thumbnail_url] = "https:" + box.css(".thumb img").attribute("src").to_s
  flags << data
end

flags.each do |flag|
  path = Pathname("_flags/#{flag[:slug]}/")
  path.mkpath
  path.join("index.md").write(<<~MARKDOWN)
    ---
    placeholder: true
    name: #{flag[:name]}
    slug: #{flag[:slug]}
    reference_url: #{flag[:reference_url]}
    thumbnail_url: #{flag[:thumbnail_url]}
    ---
  MARKDOWN
end
