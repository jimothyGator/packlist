packlist do
  name "Epic Backpacking Trip"
  description "Seven nights in the Sierras, September 2016"

  category "Shelter and sleeping" do
    # Weight for this item is  280 grams (280.g)
    item "Tarp", "2-person tarp", 280.g

    # Item quantity can be specified. Here, the weight is per
    # item, not the total weight of all items.
    # Here, we specify 8 tent stakes, at 14 grams each.
    item "Tent stakes", "Aluminum Y-stakes", 14.g, 8

    # Other units of weight can be used as well.
    #   g - grams
    #   kg - kilograms
    #   oz - ounces
    #   lb - pounds
    # Weight for this item is 24 ounces (24.oz)
    item "Sleeping back", "Down 20 degree bag", 24.oz

    # Leaving the heavy 4-season tent behind, so we comment it out
    # item "Tent", "4-season, 3-person tent", 8.5.lb
  end

  category "Clothing" do
    # On a backpacking trip, you're likely to wear some of your
    # clothes (we hope!), while others, like rain gear and extra socks
    # will be carried most of the time in your pack.
    worn "T-shirt", "Wool shirt", 150.g
    worn "Sock", "Wool socks", 80.g
    worn "Shorts", "Running shorts", 90.g

    # Some things are better left without a description. Just use an
    # empty string ("").
    worn "Underwear", "", 85.g

    # The following items are carried in the pack, not worn.
    item "Rain Jacket", "Keepin' high and dry!", 200.g
    item "Insulated Jacket", "Down duffy jacket", 275.g
    item "Warm hat", "Fleece beanie", 90.g
  end

  # Group your pack's items into multiple categories.
  category "Cooking" do
    item "Stove", "Canister stove", 90.g
    item "Cooking pot", "900ml Titanium pot", 125.g

    # Items like fuel are consumable. They are included in your
    # maximum pack weight, but not in your base weight.
    consumable "Fuel", "All season fuel blend", 110.g

    # The canister the fuel comes in is not consumable; to accurately
    # calculate your pack weight, you should list it separately.
    item "Fuel canister", "4 ounce fuel canister, empty weight", 90.g
  end

  category "Food" do
    # Food is also consumable, of course. You can use either the
    # "food" or "consumable" item type; the result is the same.

    # For each meal (breakfast, snacks, dinner), we specify the weight
    # per day, with a quantity of 7, one for each day.
    food "Breakfast", "Oatmeal", 150.g, 7
    food "Snacks", "G.O.R.P", 300.g, 7
    food "Dinner", "Dehydrated gruel", 180.g, 7
  end
end