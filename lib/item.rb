# lib/item.rb
require 'faker'
require_relative 'logger_manager'

module DvoryannikovApplication
  class Item
    include Comparable

    attr_accessor :name, :price, :description, :category, :image_path

    def initialize(params = {})
      @name = params[:name] || ""
      @price = params[:price] || 0.0
      @description = params[:description] || ""
      @category = params[:category] || ""
      @image_path = params[:image_path] || "default/path/to/image.jpg"

      yield self if block_given?

      DvoryannikovApplication::LoggerManager.log_processed_file("Initialized Item: #{self.inspect}")
    end

    def to_s
      "#{name} - #{description} (Category: #{category}, Price: #{price}, Image: #{image_path})"
    end

    def to_h
      instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete('@')] = instance_variable_get(var)
      end
    end

    def inspect
      "<Item: #{to_s}>"
    end

    alias_method :info, :to_s

    def update
      yield self if block_given?
      DvoryannikovApplication::LoggerManager.log_processed_file("Updated Item: #{self.inspect}")
    end

    def self.generate_fake
      new(
        name: Faker::Commerce.product_name,
        price: Faker::Commerce.price,
        description: Faker::Lorem.sentence,
        category: Faker::Commerce.department,
        image_path: "fake/path/to/image.jpg"
      )
    end

    def <=>(other)
      price <=> other.price
    end
  end
end
