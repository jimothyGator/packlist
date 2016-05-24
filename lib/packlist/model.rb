require 'forwardable'

module PackList
  module WeightMixin
    [:oz, :lb, :g, :kg].each do |units|
      send :define_method, units do
        return Weight.new self, units
      end
    end
  end

  class Weight
    WEIGHT_CONVERSIONS = {lb: 453.592, oz: 453.592 / 16, kg: 1000, g: 1}
    attr_reader :quantity, :units

    def initialize(quantity, units)
      raise ArgumentError, "Invalid units: #{units}" unless WEIGHT_CONVERSIONS.key?(units)
      @quantity, @units = quantity, units
    end

    [:oz, :lb, :g, :kg].each do |units|
      send :define_method, units do
        to_units units
      end
    end

    def +(w)
      # avoid changing units when either weight is zero
      case
      when w.quantity == 0
        self
      when self.quantity == 0
        w
      when w.units == @units
        Weight.new w.quantity + @quantity, @units
      else
        self + w.to_units(@units)
      end
    end

    def *(x)
      Weight.new x * @quantity, @units
    end

    ZERO = Weight.new(0, :g)

    # private
    def in_units(new_units)
      quantity * WEIGHT_CONVERSIONS[units] / WEIGHT_CONVERSIONS[new_units]
    end

    def to_units(new_units)
      Weight.new in_units(new_units), new_units
    end

    def to_s
      "#{'%.1f' % quantity} #{units}"
    end

  end


  class Item
    attr_accessor :name, :description, :weight, :quantity

    def initialize(name, description, weight, type=nil, quantity: 1)
      @name, @description, @quantity, @type = name, description, quantity, type
      @weight = weight.respond_to?(:units) ? weight : Weight.new(weight, :oz)
    end

    def total_weight
      return @weight * @quantity
    end

    def worn?
      return @type == :worn
    end

    def consumable?
      return @type == :consumable
    end

  end

  class Category
    include Enumerable
    extend Forwardable

    attr_accessor :name, :description
    attr_reader :items
    def_delegators :@items, :each, :<<, :include?, :empty?

    def initialize(name, description=nil)
      @name, @description = name, description
      @items = []
    end

    def total_weight
      @items.collect {|item| item.total_weight}.reduce(Weight::ZERO, :+)
    end

    def total_pack_weight
      base_weight + consumable_weight
    end

    def worn_weight
      items = @items.select {|item| item.worn? }
      items.collect {|item| item.total_weight}.reduce(Weight::ZERO, :+)
    end

    def consumable_weight
      items = @items.select {|item| item.consumable? }
      items.collect {|item| item.total_weight}.reduce(Weight::ZERO, :+)
    end

    def base_weight
      items = @items.reject {|item| item.worn? || item.consumable? }
      items.collect {|item| item.total_weight}.reduce(Weight::ZERO, :+)
    end

    def total_quantity
      @items.collect {|item| item.quantity}.reduce(0, :+)
    end

    def item_count
      @items.length
    end

  end

  class PackList
    include Enumerable
    extend Forwardable

    attr_accessor :name, :description
    attr_reader :categories
    def_delegators :@categories, :each, :<<, :include?, :empty?

    def initialize(name, description=nil, categories=[])
      @name, @description = name, description

      @categories = categories
    end

    def total_weight
      @categories.collect {|category| category.total_weight}.reduce(Weight::ZERO, :+)
    end

    def total_pack_weight
      base_weight + consumable_weight
    end

    def worn_weight
      @categories.collect {|category| category.worn_weight}.reduce(Weight::ZERO, :+)
    end

    def consumable_weight
      @categories.collect {|category| category.consumable_weight}.reduce(Weight::ZERO, :+)
    end

    def base_weight
      @categories.collect {|category| category.base_weight}.reduce(Weight::ZERO, :+)
    end

    def total_quantity
      @categories.collect {|category| category.total_quantity}.reduce(0, :+)
    end

    def item_count
      @categories.collect {|category| category.item_count}.reduce(0, :+)
    end

  end
end

class Numeric
  include PackList::WeightMixin
end