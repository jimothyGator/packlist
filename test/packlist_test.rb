require 'packlist'
require 'test_helper'

describe Weight do
	it 'can be multipled by a scalar' do
		weight = Weight.new 13, :oz
		total = weight * 3

		total.quantity.must_equal 39
		total.units.must_equal weight.units
	end

	it 'can be added to another weight with same units' do
		w1 = Weight.new 40, :g
		w2 = Weight.new 35, :g
		total = w1 + w2

		total.quantity.must_equal 75
	end

	it 'can be added to another weight with different units' do
		w1 = Weight.new 40, :g
		w2 = Weight.new 1.5, :kg
		total = w1 + w2

		total.quantity.must_equal 1540
	end

	it 'can convert from ounces to grams' do
		w = Weight.new 10, :oz

		w.grams.must_be_close_to 283, 0.5
	end

	it 'can convert from grams to ounces' do
		w = Weight.new 200, :g

		w.ounces.must_be_close_to 7.1, 0.05
	end

	it 'can convert from ounces to pounds' do
		w = Weight.new 40, :oz

		w.pounds.must_equal 2.5
	end

	it 'will raise an exception if units are used' do
		lambda { new Weight.new 1, :km}.must_raise ArgumentError
	end
end

describe Item do
	it 'defaults weight units to ounces' do
		item = Item.new("Backpage", "Osprey Exos 48", 40)

		item.weight.units.must_equal :oz
	end

	it 'calculates total weight for unit weight and quantity' do
		item = Item.new("tent stake", "MSR Mini Groundhog", 10, :g, quantity: 6)

		item.total_weight.grams.must_equal 60
	end
end

describe Category do
	it 'is a collection of items' do
		cat = Category.new("Clothing")
		i1 = Item.new("shirt", "Merino wool shirt", 8)
		i2 = Item.new("shorts", "Running shorts", 4)

		cat << i1 << i2

		cat.must_include i1
		cat.must_include i2
	end

	it 'calculates total weight for all items' do
		cat = Category.new("Clothing")
		i1 = Item.new("shirt", "Merino wool shirt", 8)
		i2 = Item.new("shorts", "Running shorts", 4)
		i3 = Item.new("socks", "wool socks", 3, quantity: 2)
		cat  << i1 << i2 << i3

		total = cat.total_weight
		total.ounces.must_equal 18
	end

	it 'has a zero total weight when empty' do
		cat = Category.new "Fishing equipment"

		cat.total_weight.ounces.must_equal 0
	end

	it 'does not include consumable items in pack weight' do
		cat = Category.new("Cooking")
		cat << Item.new("stove", "fancy feast", 18, :g)
		cat << Item.new("fuel bottle", "soda bottle", 28, :g)
		cat << Item.new("fuel", "alcohol", 24.2, :g, :consumable, quantity: 16)

		weight = cat.pack_weight
		weight.grams.must_equal 46
	end

	it 'only includes consumable items in consumable weight' do
		cat = Category.new("Cooking")
		cat << Item.new("stove", "fancy feast", 18, :g)
		cat << Item.new("fuel bottle", "soda bottle", 28, :g)
		cat << Item.new("fuel", "alcohol", 24.2, :g, :consumable, quantity: 16)

		weight = cat.consumable_weight
		weight.grams.must_be_close_to 387, 0.5
	end

	it 'does not include worn items in pack weight' do
		cat = Category.new("Clothing")
		cat << Item.new("socks", "wool socks", 85, :g, :worn)
		cat << Item.new("shirt", "short sleeves", 180, :g, :worn)
		cat << Item.new("extra socks", "wool socks", 85, :g)

		weight = cat.pack_weight
		weight.grams.must_equal 85
	end

	it 'only includes worn items in worn weight' do
		cat = Category.new("Clothing")
		cat << Item.new("socks", "wool socks", 85, :g, :worn)
		cat << Item.new("shirt", "short sleeves", 180, :g, :worn)
		cat << Item.new("extra socks", "wool socks", 85, :g)

		weight = cat.worn_weight
		weight.grams.must_equal 265
	end

end

describe PackList do
	it 'has a zero total weight when empty' do
		pack = PackList.new "Fall backpacking trip"

		pack.total_weight.ounces.must_equal 0
	end

	it 'is a collection of categories' do
		pack = Category.new("Backpacking Trip")
		c1 = Category.new "Clothing"
		c2 = Category.new "Shelter"
		c3 = Category.new "Scuba Gear"

		pack << c1 << c2

		pack.must_include c1
		pack.must_include c2
		pack.wont_include c3
	end

	it 'calculates total weight for all categories' do
		c1 = Category.new "Clothing"
		i1 = Item.new("shirt", "Merino wool shirt", 8)
		i2 = Item.new("shorts", "Running shorts", 4)
		i3 = Item.new("socks", "wool socks", 3, quantity: 2)
		c1  << i1 << i2 << i3

		c2 = Category.new "Shelter"
		i2 = Item.new("tarp", "cuben fiber tarp", 8, :oz)
		i3 = Item.new("stakes", "MSR Mini Groundhog", 10, :g, quantity: 6)
		c2 << i2 << i3

		pack = PackList.new "Fall backpacking trip"
		pack << c1 << c2

		total = pack.total_weight
		total.ounces.must_be_close_to 28, 0.5
	end

	it 'does not include consumable and worn items in pack weight' do
		c1 = Category.new("Cooking")
		c1 << Item.new("stove", "fancy feast", 18, :g)
		c1 << Item.new("fuel bottle", "soda bottle", 28, :g)
		c1 << Item.new("fuel", "alcohol", 24.2, :g, :consumable, quantity: 16)

		c2 = Category.new("Clothing")
		c2 << Item.new("socks", "wool socks", 85, :g, :worn)
		c2 << Item.new("shirt", "short sleeves", 180, :g, :worn)
		c2 << Item.new("extra socks", "wool socks", 85, :g)

		pack = PackList.new "Fall backpacking trip"
		pack << c1 << c2

		weight = pack.pack_weight
		weight.grams.must_equal 131
	end

	it 'only includes consumable items in consumable weight' do
		c1 = Category.new("Cooking")
		c1 << Item.new("stove", "fancy feast", 18, :g)
		c1 << Item.new("fuel bottle", "soda bottle", 28, :g)
		c1 << Item.new("fuel", "alcohol", 24.2, :g, :consumable, quantity: 16)

		c2 = Category.new("Clothing")
		c2 << Item.new("socks", "wool socks", 85, :g, :worn)
		c2 << Item.new("shirt", "short sleeves", 180, :g, :worn)
		c2 << Item.new("extra socks", "wool socks", 85, :g)

		pack = PackList.new "Fall backpacking trip"
		pack << c1 << c2

		weight = pack.consumable_weight
		weight.grams.must_be_close_to 387, 0.5
	end

	it 'only includes worn items in worn weight' do
		c1 = Category.new("Cooking")
		c1 << Item.new("stove", "fancy feast", 18, :g)
		c1 << Item.new("fuel bottle", "soda bottle", 28, :g)
		c1 << Item.new("fuel", "alcohol", 24.2, :g, :consumable, quantity: 16)

		c2 = Category.new("Clothing")
		c2 << Item.new("socks", "wool socks", 85, :g, :worn)
		c2 << Item.new("shirt", "short sleeves", 180, :g, :worn)
		c2 << Item.new("extra socks", "wool socks", 85, :g)

		pack = PackList.new "Fall backpacking trip"
		pack << c1 << c2

		weight = pack.worn_weight
		weight.grams.must_equal 265
	end


end


