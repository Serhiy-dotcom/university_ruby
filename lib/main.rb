require_relative "scraper"

url = "https://www.wikipedia.com.ua"
scraper = Scraper.new(url)

puts "Заголовки на сторінці:"
scraper.extract_headings.each do |heading|
  puts heading
end
