require_relative './lib/configurator'

configurator = StoreApplication::Configurator.new

puts "Initial Configuration:"
puts configurator.config

configurator.configure(
  run_website_parser: 1,
  run_save_to_csv: 1,
  run_save_to_yaml: 1,
  run_save_to_sqlite: 1,
  invalid_key: 1
)

puts "\nUpdated Configuration:"
puts configurator.config

puts "\nAvailable Methods:"
puts StoreApplication::Configurator.available_methods
