require_relative './lib/item'
require_relative './lib/logger_manager'

item = DvoryannikovApplication::Item.new(name: "Test Product", price: 100) do |i|
  i.description = "Test description"
  i.category = "Test category"
end

puts item.to_s
puts item.to_h
puts item.inspect

item.update do |i|
  i.name = "Updated Product"
  i.price = 200
end

puts item.info

fake_item = DvoryannikovApplication::Item.generate_fake
puts fake_item.to_s
