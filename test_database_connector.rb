require_relative './lib/database_connector'
require 'yaml'

config = YAML.load_file('./config/config.yml')

# Test SQLite connection
puts "Testing SQLite connection..."
sqlite_connector = StoreApplication::DatabaseConnector.new(config.merge('database_type' => 'sqlite'))
sqlite_connector.connect_to_database
sqlite_connector.close_connection

# Test MongoDB connection
puts "\nTesting MongoDB connection..."
mongo_connector = StoreApplication::DatabaseConnector.new(config.merge('database_type' => 'mongodb'))
mongo_connector.connect_to_database
mongo_connector.close_connection
