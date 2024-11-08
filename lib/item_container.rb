require 'json'
require 'csv'
require 'yaml'
require_relative 'logger_manager'
require_relative 'item'
require_relative 'item_container'

module StoreApplication
  class Cart
    include ItemContainer
    include Enumerable

    attr_accessor :items

    def initialize
      @items = []
      LoggerManager.log_processed_file("Cart initialized")
    end

    def save_to_file(filename = 'items.txt')
      File.open(filename, 'w') do |file|
        @items.each { |item| file.puts(item.to_s) }
      end
      LoggerManager.log_processed_file("Saved items to #{filename}")
    end

    def save_to_json(filename = 'items.json')
      File.write(filename, @items.map(&:to_h).to_json)
      LoggerManager.log_processed_file("Saved items to #{filename}")
    end

    def save_to_csv(filename = 'items.csv')
      CSV.open(filename, 'w') do |csv|
        csv << @items.first.to_h.keys
        @items.each { |item| csv << item.to_h.values }
      end
      LoggerManager.log_processed_file("Saved items to #{filename}")
    end

    def save_to_yml(directory = 'items_yml')
      Dir.mkdir(directory) unless Dir.exist?(directory)
      @items.each_with_index do |item, index|
        File.write("#{directory}/item_#{index + 1}.yml", item.to_h.to_yaml)
      end
      LoggerManager.log_processed_file("Saved items to YAML files in #{directory}")
    end

    def each(&block)
      @items.each(&block)
    end

    def generate_test_items(count = 5)
      count.times do
        add_item(StoreApplication::Item.generate_fake)
      end
      LoggerManager.log_processed_file("Generated #{count} test items")
    end
  end
end
