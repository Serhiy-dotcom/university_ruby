require_relative './lib/configurator'

# Initialize configurator with default settings
configurator = StoreApplication::Configurator.new

# Print current configuration
puts "Initial Configuration:"
puts configurator.config

# Configure with overrides
configurator.configure(
  run_website_parser: 1,
  run_save_to_csv: 1,
  run_save_to_yaml: 1,
  run_save_to_sqlite: 1,
  invalid_key: 1 # Testing an invalid key
)

# Print updated configuration
puts "\nUpdated Configuration:"
puts configurator.config

# List available configuration keys
puts "\nAvailable Methods:"
puts StoreApplication::Configurator.available_methods
