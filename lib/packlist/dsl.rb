class PackBuilder
  attr_reader :pack

  def initialize(name, description, &block)
    @pack = PackList.new(name, description)
    instance_eval(&block)
  end

  def category(name, description=nil, &block)
    builder = CategoryBuilder.new name, description, &block
    @pack << builder.category
  end
end


class CategoryBuilder
  attr_reader :category

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

  private 

  def add_item(name, description, weight, units, type, quantity)
    item = Item.new(name, description, weight, units, type, quantity: quantity)
    @category << item
  end

end


def packlist(name, description=nil, &block)
  builder = PackBuilder.new name, description, &block

  builder.pack
end
