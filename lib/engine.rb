require 'yaml'
require 'sidekiq'
require 'zip'
require 'pony'
require_relative 'logger_manager'
require_relative 'simple_website_parser'
require_relative 'database_connector'
require_relative 'cart'
# require_relative 'archive_sender'

module StoreApplication
  class Engine
    attr_accessor :config

    def initialize(config_path)
      @config_path = config_path
      @config = load_config
      initialize_logging
      StoreApplication::LoggerManager.log_processed_file("Engine initialized with configuration #{@config_path}")
    end

	def invoke_methods_based_on_config
		@config.each do |key, value|
		  next unless value == 1
		  method_name = key.start_with?('run_') ? key : "run_#{key}"
		  if respond_to?(method_name)
			send(method_name)
		  else
			StoreApplication::LoggerManager.log_error("Method #{method_name} not found.")
		  end
		end
	  end

    def load_config
		config_data = YAML.load_file(@config_path)
		StoreApplication::LoggerManager.log_processed_file("Configuration loaded successfully")
		config_data
	  rescue => e
		StoreApplication::LoggerManager.log_error("Failed to load configuration: #{e.message}")
		{}
	  end

    def run_methods(config_params)
      config_params.each do |method_name, enabled|
        next unless enabled == 1
        
        method_symbol = "run_#{method_name}".to_sym
        if respond_to?(method_symbol, true)
          send(method_symbol)
        else
          StoreApplication::LoggerManager.log_error("Method #{method_symbol} not found.")
        end
      end
    end

    def run
      database_connector = DatabaseConnector.new(@config)
      database_connector.connect_to_database

    #   run_methods(@config)
	invoke_methods_based_on_config

      database_connector.close_connection
      archive_results if @config['enable_archive'] == 1
    end

    def run_website_parser
		parser = SimpleWebsiteParser.new(@config_path)
		@cart = Cart.new
		
		items = parser.start_parse
		if items.nil? || items.empty?
		  StoreApplication::LoggerManager.log_processed_file("No items were parsed.")
		else
		  items.each { |item| @cart.add_item(item) }
		end
		StoreApplication::LoggerManager.log_processed_file("Items in cart: #{items}")

		StoreApplication::LoggerManager.log_processed_file("Website parsing completed.")
	  end
	  

    def run_save_to_csv
      @cart.save_to_csv
      StoreApplication::LoggerManager.log_processed_file("Data saved to CSV.")
    end

    def run_save_to_json
      @cart.save_to_json
      StoreApplication::LoggerManager.log_processed_file("Data saved to JSON.")
    end

    def run_save_to_yaml
      @cart.save_to_yml
      StoreApplication::LoggerManager.log_processed_file("Data saved to YAML.")
    end

    def run_save_to_sqlite
      database_connector = DatabaseConnector.new(@config)
      database_connector.save_items_to_sqlite(@cart.items)
      StoreApplication::LoggerManager.log_processed_file("Data saved to SQLite.")
    end

    def run_save_to_mongodb
      database_connector = DatabaseConnector.new(@config)
      database_connector.save_items_to_mongodb(@cart.items)
      StoreApplication::LoggerManager.log_processed_file("Data saved to MongoDB.")
    end

    def archive_results
      archive_file = "results_#{Time.now.to_i}.zip"
      Zip::File.open(archive_file, Zip::File::CREATE) do |zipfile|
        Dir["output/*"].each do |file|
          zipfile.add(File.basename(file), file)
        end
      end
      StoreApplication::LoggerManager.log_processed_file("Results archived in #{archive_file}")
    #   ArchiveSender.perform_async(archive_file) if @config['enable_email'] == 1
    end

	private

    def initialize_logging
      StoreApplication::LoggerManager.setup_logging(@config)
    end
  end
end
