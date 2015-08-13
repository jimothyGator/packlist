require 'packlist/version'
require 'forwardable'

class Weight
  @@weight_conversions = {lb: 453.592, oz: 453.592 / 16, kg: 1000, g: 1}
  attr_reader :quantity, :units

  def self.zero
    ZERO
  end

  def initialize(quantity, units)
    raise ArgumentError, "Invalid units: #{units}" unless @@weight_conversions.key?(units)
    @quantity, @units = quantity, units
  end

  def grams
    quantity * @@weight_conversions[units]
  end

  def ounces
    grams / @@weight_conversions[:oz]
  end

  def pounds
    grams / @@weight_conversions[:lb]
  end

  def kilograms
    grams / @@weight_conversions[:kg]
  end

  def *(x)
    Weight.new x * @quantity, @units
  end

  def +(w)
    if w.units == @units
      Weight.new w.quantity + @quantity, @units
    else
      total_grams = grams + w.grams
      total_quantity = total_grams / @@weight_conversions[units]
      Weight.new total_quantity, @units
    end
  end

  ZERO = Weight.new(0, :g)

end


class Item
  attr_accessor :name, :description, :weight, :quantity

  def initialize(name, description, weight, units=:oz, type=nil, quantity: 1)
    @name, @description, @quantity, @type = name, description, quantity, type
    @weight = Weight.new(weight, units)
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
    empty? ? Weight.zero : @items.collect {|item| item.total_weight}.reduce(:+)
  end

  def worn_weight
    items = @items.select {|item| item.worn? }
    items.empty? ? Weight.zero : items.collect {|item| item.total_weight}.reduce(:+)
  end

  def consumable_weight
    items = @items.select {|item| item.consumable? }
    items.empty? ? Weight.zero : items.collect {|item| item.total_weight}.reduce(:+)
  end

  def pack_weight
    items = @items.reject {|item| item.worn? || item.consumable? }
    items.empty? ? Weight.zero : items.collect {|item| item.total_weight}.reduce(:+)
  end

end

class PackList
  include Enumerable
  extend Forwardable

  attr_accessor :name, :description
  attr_reader :categories
  def_delegators :@categories, :each, :<<, :include?, :empty?

  def initialize(name, description=nil)
    @name, @description = name, description

    @categories = []
  end

  def total_weight
    empty? ? Weight.zero : @categories.collect {|category| category.total_weight}.reduce(:+)
  end

  def worn_weight
    empty? ? Weight.zero : @categories.collect {|category| category.worn_weight}.reduce(:+)
  end

  def consumable_weight
    empty? ? Weight.zero : @categories.collect {|category| category.consumable_weight}.reduce(:+)
  end

  def pack_weight
    empty? ? Weight.zero : @categories.collect {|category| category.pack_weight}.reduce(:+)
  end

end
