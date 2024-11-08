module StoreApplication
	class Configurator
	  attr_accessor :config
  
	  # Step 2: Initialize with default configuration values
	  def initialize
		@config = {
		  run_website_parser: 0,    # Run website parser
		  run_save_to_csv: 0,       # Save data in CSV format
		  run_save_to_json: 0,      # Save data in JSON format
		  run_save_to_yaml: 0,      # Save data in YAML format
		  run_save_to_sqlite: 0,    # Save data in SQLite database
		  run_save_to_mongodb: 0    # Save data in MongoDB database
		}
		puts "[INFO] Configurator initialized with default settings"
	  end
  
	  # Step 3: Method to update configuration with overrides
	  def configure(overrides = {})
		overrides.each do |key, value|
		  if @config.key?(key)
			@config[key] = value
			puts "[INFO] Updated config: #{key} = #{value}"
		  else
			puts "[WARNING] Invalid configuration key: #{key}"
		  end
		end
	  end
  
	  # Step 4: Class method to list available configuration keys
	  def self.available_methods
		%i[
		  run_website_parser
		  run_save_to_csv
		  run_save_to_json
		  run_save_to_yaml
		  run_save_to_sqlite
		  run_save_to_mongodb
		]
	  end
	end
  end