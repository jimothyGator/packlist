require 'packlist/version'
require 'forwardable'

class Weight
  @@weight_conversions = {lb: 453.592, oz: 453.592 / 16, kg: 1000, g: 1}
  attr_reader :quantity, :units

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
end


class Item
  attr_accessor :name, :description, :weight, :quantity

  def initialize(name, description, weight, units=:oz, quantity: 1)
    @name, @description, @quantity = name, description, quantity
    @weight = Weight.new(weight, units)
  end

  def total_weight
    return @weight * @quantity
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
    empty? ? Weight.new(0, :g) : @items.collect {|item| item.total_weight}.reduce(:+)
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
    empty? ? Weight.new(0, :g) : @categories.collect {|category| category.total_weight}.reduce(:+)
  end
end
