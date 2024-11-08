require 'logger'
require_relative 'app_config_loader'

module DvoryannikovApplication
  class LoggerManager
    def self.log_processed_file(message)
		puts "[INFO] #{message}"
	  end
  
	  def self.log_error(error)
		puts "[ERROR] #{error}"
	  end
  end
end
