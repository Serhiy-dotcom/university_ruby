require_relative './lib/cart'
require_relative './lib/item'

cart = StoreApplication::Cart.new

# Generate test items
cart.generate_test_items(3)

# Save to various formats
cart.save_to_file
cart.save_to_json
cart.save_to_csv
cart.save_to_yml

# Use Enumerable methods
puts "All items:"
cart.show_all_items

puts "\nItems in Electronics category:"
electronics = cart.select { |item| item.category == "Electronics" }
electronics.each { |item| puts item }

puts "\nSorted items by price:"
sorted_items = cart.sort_by(&:price)
sorted_items.each { |item| puts item }
