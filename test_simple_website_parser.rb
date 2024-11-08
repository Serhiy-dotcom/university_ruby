require_relative './lib/simple_website_parser'

parser = StoreApplication::SimpleWebsiteParser.new('./config/config.yml')

parser.start_parse

parser.item_collection.items.each do |item|
  puts item.info
end
