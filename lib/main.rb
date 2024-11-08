require_relative 'app_config_loader'
require_relative 'logger_manager'

module LakustaApplication
	class Main
	  def self.start
		config_loader = AppConfigLoader.new('config/default_config.yaml', 'config')
		puts "Підключення бібліотек..."
		config_loader.load_libs
		puts "Бібліотеки підключено успішно."

		puts "Завантаження конфігурацій..."
		config_data = config_loader.config
		puts "Конфігурації завантажено успішно."

		puts "Перевірка завантаження конфігурацій:"
		config_loader.pretty_print_config_data

		LoggerManager.initialize_logger(config_data)
		LoggerManager.log_processed_file('app.log')
		LoggerManager.log_error('Log error')
		puts "Логування налаштовано. Перевірте app.log для записаних подій."
	  end
	end
end

LakustaApplication::Main.start
