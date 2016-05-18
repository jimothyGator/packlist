require 'packlist/model'

module PackList
  module DSL
    def packlist(&block)
      builder = PackBuilder.new &block
      builder.build
    end
    module_function :packlist

    class PackBuilder
      def initialize(&block)
        @categories = []
        if block_given?
          instance_eval &block
        end
      end

      def name(name)
        @name = name
        self
      end

      def description(description)
        @description = description
        self
      end

      def build
        PackList.new @name, @description, @categories
      end

      def category(name, description=nil, &block)
        cat_builder = CategoryBuilder.new name, description, &block
        category = cat_builder.build
        @categories << category
        category
      end
    end


    class CategoryBuilder
      def initialize(name, description, &block)
        @category = Category.new name, description
        if block_given?
          instance_eval(&block)
        end
      end

      def item(name, description, weight, units=:oz, quantity=1)
        add_item(name, description, weight, units, nil, quantity)
      end

      def worn(name, description, weight, units=:oz, quantity=1)
        add_item(name, description, weight, units, :worn, quantity)
      end

      def consumable(name, description, weight, units=:oz, quantity=1)
        add_item(name, description, weight, units, :consumable, quantity)
      end

      def food(name, description, weight, units=:oz, quantity=1)
        add_item(name, description, weight, units, :consumable, quantity)
      end

      def build
        @category
      end

      private 

      def add_item(name, description, weight, units, type, quantity)
        item = Item.new(name, description, weight, units, type, quantity: quantity)
        @category << item
      end

    end

    def self.load(filename)
      instance_eval(File.read(filename), filename)
    end
  end
end