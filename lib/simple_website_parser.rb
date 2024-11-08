require 'mechanize'
require 'nokogiri'
require 'yaml'
require_relative 'item'
require_relative 'logger_manager'
require_relative 'cart'

module StoreApplication
  class SimpleWebsiteParser
    attr_reader :config, :agent, :item_collection

    def initialize(config_file)
      @config = YAML.load_file(config_file)
      @agent = Mechanize.new
      @item_collection = Cart.new
      StoreApplication::LoggerManager.log_processed_file("Initialized SimpleWebsiteParser with config: #{@config}")
    end

    def start_parse
		@processed_links = Set.new
		product_links = extract_products_links(@agent.get(@config['start_url']))
	  
		product_links.each do |link|
			StoreApplication::LoggerManager.log_processed_file("Link found #{link}")
		  next if @processed_links.include?(link)
	  
		  parse_product_page(link)
		  @processed_links.add(link)
		end
	  
		StoreApplication::LoggerManager.log_processed_file("Parsing completed with #{@item_collection.items.count} products")
	  end

    def extract_products_links(page)
      selector = @config['product_link_selector']
      links = page.search(selector).map { |link| link['href'] }
      StoreApplication::LoggerManager.log_processed_file("Extracted #{links.size} product links")
      links
    end

	def parse_product_page(product_link)
		url = URI.join(@config['base_url'], URI::DEFAULT_PARSER.escape(product_link)).to_s
		return unless check_url_response(url)
		StoreApplication::LoggerManager.log_processed_file("url: #{url}")
		product_page = @agent.get(url)
		StoreApplication::LoggerManager.log_processed_file("product_page: #{product_page}")
		return unless product_page.is_a?(Mechanize::Page)
	  
		name = extract_product_name(product_page)
		price = extract_product_price(product_page)
		description = extract_product_description(product_page)
		image_url = extract_product_image(product_page)
		image_path = save_image(image_url, name) if image_url

		if name && price && description && image_path && !@item_collection.items.any? { |item| item.name == name }
		  item = Item.new(
			name: name,
			price: price,
			description: description,
			category: @config['category'],
			image_path: image_path
		  )
	  
		  @item_collection.add_item(item)
		  StoreApplication::LoggerManager.log_processed_file("Parsed product: #{name}")
		else
		  StoreApplication::LoggerManager.log_error("Incomplete or duplicate product data on #{url}; skipping item.")
		end
	  end

	  def extract_product_name(product_page)
		name_element = product_page.at(@config['name_selector'])
		if name_element
		  name_element.text.strip
		else
		  StoreApplication::LoggerManager.log_error("Product name not found on page.")
		  nil
		end
	  end

	  def extract_product_price(product_page)
		price_element = product_page.at(@config['price_selector'])
		if price_element
		  price_text = price_element.text.strip
		  price_text.gsub(/[^\d\.]/, '').to_f
		else
		  StoreApplication::LoggerManager.log_error("Product price not found on page.")
		  nil
		end
	  end

	  def extract_product_description(product_page)
		description_element = product_page.at(@config['description_selector'])
		if description_element
		  description_element.text.strip
		else
		  StoreApplication::LoggerManager.log_error("Product description not found on page.")
		  nil
		end
	  end

    def extract_product_image(product_page)
      img = product_page.at(@config['image_selector'])
      img ? img['src'] : nil
    end

    def check_url_response(url)
		response = @agent.head(url)
		if response.code == '200'
		  true
		else
		  StoreApplication::LoggerManager.log_error("Error accessing #{url}: #{response.code} => #{response.message}")
		  false
		end
	  rescue Mechanize::ResponseCodeError => e
		StoreApplication::LoggerManager.log_error("Error accessing #{url}: #{e.message}")
		false
	  end

	  def save_image(image_url, product_name)
		return unless image_url

		unique_id = Time.now.to_i.to_s

		sanitized_name = product_name.gsub(' ', '_').gsub(/[^0-9A-Za-z_]/, '')
		filename = "#{sanitized_name}_#{unique_id}.jpg"

		category_dir = File.join('media_dir', @config['category'])
		FileUtils.mkdir_p(category_dir) unless Dir.exist?(category_dir)

		image_path = File.join(category_dir, filename)

		@agent.get(image_url).save(image_path)
		StoreApplication::LoggerManager.log_processed_file("Saved image for #{product_name} to #{image_path}")
		image_path
	  end
  end
end
