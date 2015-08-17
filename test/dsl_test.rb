require 'packlist'
require 'packlist/dsl'
require 'test_helper'

describe "DSL" do
	it "defines a packlist with a title and description" do
		pl = PackList::packlist "packlist title", "packlist description" do
		end

		pl.name.must_equal "packlist title"
		pl.description.must_equal "packlist description"
	end

	it "can define a packlist with only a title" do
		pl = PackList::packlist "packlist title" do
		end

		pl.name.must_equal "packlist title"
		pl.description.must_be_nil
	end		

	it "can define a category with only a title" do
		pl = PackList::packlist "packlist title" do
			category "category title"
		end

		pl.categories.first.name.must_equal "category title"
		pl.categories.first.description.must_be_nil
	end		

	it "defines categories in a packlist" do
		pl = PackList::packlist "packlist title" do
			category "first category", "first category description" do
			end

			category "second category", "second category description" do
			end
		end

		pl.categories.length.must_equal 2

		pl.categories[0].name.must_equal "first category"
		pl.categories[0].description.must_equal "first category description"

		pl.categories[1].name.must_equal "second category"
		pl.categories[1].description.must_equal "second category description"
	end		

	it "defines items in a category packlist" do
		pl = PackList::packlist "packlist title" do
			category "shelter" do
				item "tent", "Big Agnes Copper Spur UL3", 4, :lb
			end
		end

		item = pl.categories.first.items.first;
		item.name.must_equal "tent"
		item.description.must_equal "Big Agnes Copper Spur UL3"
		item.weight.pounds.must_equal 4
	end		

	it "can specify quantity for an item" do
		pl = PackList::packlist "packlist title" do
			category "shelter" do
				item "stakes", "MSR Mini Groundhog", 10, :g, 6
			end
		end

		item = pl.categories.first.items.first;
		item.quantity.must_equal 6
	end		

	it "can specify worn items" do
		pl = PackList::packlist "packlist title" do
			category "clothing" do
				worn "shirt", "short sleeve shirt", 6, :oz
			end
		end

		item = pl.categories.first.items.first;
		item.worn?.must_equal true
		item.consumable?.must_equal false
	end		

	it "can specify consumable items" do
		pl = PackList::packlist "packlist title" do
			category "food" do
				consumable "candy", "M&Ms", 2, :oz
			end
		end

		item = pl.categories.first.items.first;
		item.consumable?.must_equal true
		item.worn?.must_equal false
	end		

	it "marks food items as consumable" do
		pl = PackList::packlist "packlist title" do
			category "food" do
				food "candy", "M&Ms", 2, :oz
			end
		end

		item = pl.categories.first.items.first;
		item.consumable?.must_equal true
		item.worn?.must_equal false
	end		


end