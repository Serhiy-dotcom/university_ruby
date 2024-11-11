require 'sqlite3'
require 'mongo'
require 'yaml'
require_relative 'logger_manager'

module StoreApplication
  class DatabaseConnector
    attr_reader :db

    def initialize(config)
      @config = config
      @db = nil
    end

    def connect_to_database
      case @config['database_type']
      when 'sqlite'
        connect_to_sqlite
      when 'mongodb'
        connect_to_mongodb
      else
        StoreApplication::LoggerManager.log_error("Unsupported database type: #{@config['database_type']}")
      end
    rescue => e
      StoreApplication::LoggerManager.log_error("Database connection failed: #{e.message}")
    end

    def close_connection
      if @db
        case @config['database_type']
        when 'sqlite'
          @db.close if @db.respond_to?(:close)
        when 'mongodb'
          @client.close if @client
        end
        StoreApplication::LoggerManager.log_processed_file("Database connection closed.")
      end
    rescue => e
      StoreApplication::LoggerManager.log_error("Error closing database connection: #{e.message}")
    ensure
      @db = nil
    end

	def save_items_to_sqlite(items)
		unless @db
		  StoreApplication::LoggerManager.log_error("Database connection not established. Skipping saving items to SQLite.")
		  return
		end
	  
		items.each do |item|
		  @db.execute("INSERT INTO items (name, price, description, category, image_path) VALUES (?, ?, ?, ?, ?)", 
					  [item.name, item.price, item.description, item.category, item.image_path])
		end
		StoreApplication::LoggerManager.log_processed_file("Data saved to SQLite.")
	  rescue SQLite3::Exception => e
		StoreApplication::LoggerManager.log_error("Error saving items to SQLite: #{e.message}")
	  end

    private

    def connect_to_sqlite
      db_path = @config['sqlite_path']
      @db = SQLite3::Database.new(db_path)
      StoreApplication::LoggerManager.log_processed_file("Connected to SQLite database at #{db_path}.")
	  create_items_table
    end

	def create_items_table
		@db.execute <<-SQL
		  CREATE TABLE IF NOT EXISTS items (
			id INTEGER PRIMARY KEY,
			name TEXT,
			price REAL,
			description TEXT,
			category TEXT,
			image_path TEXT
		  );
		SQL
	end

    def connect_to_mongodb
      uri = @config['mongodb_uri']
      db_name = @config['mongodb_database']
      @client = Mongo::Client.new(uri, database: db_name)
      @db = @client.database
      StoreApplication::LoggerManager.log_processed_file("Connected to MongoDB database #{db_name}.")
    end
  end
end
