module StoreApplication
  module ItemContainer
    module ClassMethods
      def class_info
        "Class: #{name}, Version: 1.0"
      end

      def object_count
        @object_count ||= 0
      end

      def increment_object_count
        @object_count = object_count + 1
      end
    end

    module InstanceMethods
      def add_item(item)
        @items << item
        StoreApplication::LoggerManager.log_processed_file("Added item: #{item.inspect}")
      end

      def remove_item(item)
        @items.delete(item)
        StoreApplication::LoggerManager.log_processed_file("Removed item: #{item.inspect}")
      end

      def delete_items
        @items.clear
        StoreApplication::LoggerManager.log_processed_file("Cleared all items from cart")
      end

      def method_missing(method_name, *arguments, &block)
        if method_name == :show_all_items
          @items.each { |item| puts item }
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name == :show_all_items || super
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end
  end
end
