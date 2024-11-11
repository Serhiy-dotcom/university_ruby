require_relative 'app_config_loader'
require_relative 'logger_manager'
require_relative 'engine'

module StoreApplication
  class Main
    def self.start
      config_loader = AppConfigLoader.new('config/config.yml', 'config')
      puts "Підключення бібліотек..."
      config_loader.load_libs
      puts "Бібліотеки підключено успішно."

      puts "Завантаження конфігурацій..."
      config_data = config_loader.config
      puts "Конфігурації завантажено успішно."

      puts "Перевірка завантаження конфігурацій:"
      config_loader.pretty_print_config_data

      LoggerManager.setup_logging(config_data)
      LoggerManager.log_processed_file('app.log')
      LoggerManager.log_error('Log error')
      puts "Логування налаштовано. Перевірте app.log для записаних подій."

      engine = Engine.new('config/config.yml')
      engine.run
    end
  end
end

StoreApplication::Main.start