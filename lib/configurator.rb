module StoreApplication
	class Configurator
	  attr_accessor :config

	  def initialize
		@config = {
		  run_website_parser: 0,
		  run_save_to_csv: 0,
		  run_save_to_json: 0,
		  run_save_to_yaml: 0,
		  run_save_to_sqlite: 0,
		  run_save_to_mongodb: 0
		}
		puts "[INFO] Configurator initialized with default settings"
	  end

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