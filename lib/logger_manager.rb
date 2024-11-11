require 'logger'
require_relative 'app_config_loader'

module StoreApplication
  class LoggerManager
	def self.setup_logging(config_data)
		@logger = Logger.new('app.log')
		@logger.level = Logger::INFO
		@logger.info("Logging initialized with configuration.")
	  end

    def self.log_processed_file(message)
		puts "[INFO] #{message}"
	  end
  
	  def self.log_error(error)
		puts "[ERROR] #{error}"
	  end
  end
end
