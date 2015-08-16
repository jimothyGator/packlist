require 'packlist/model'
require 'prawn'


module PackList
	class Report
		include Prawn::View

		def initialize(packlist, filename)
			@packlist, @filename = packlist, filename

			font_size 11
			render_categories packlist
			save_as filename
		end

		def render_categories(categories)
			categories.each do |category|
				render_category category
			end
		end

		def render_category(category)
			if ! category.empty?
				text category.name, style: :bold, size: 12
				hr 2, 5

				render_items category
				move_down 1

				h_margin = 5
				x = 54
				width = 430
				text_box "Subtotal", at: [x, cursor], width: width, single_line: true, style: :bold, align: :right, size: 12
				
				x += width + h_margin
				width = 50
				text_box "#{category.total_weight.pounds.round(2)} lb", at: [x, cursor], width: width, single_line: true, align: :right, style: :bold, size: 12
				
				move_down 20
			end

		end

		def render_items(items)
			items.each do |item|
				render_item item
			end
		end

		def render_item(item)
			h_margin = 5

			# Checkbox
			x = 5
			width = 12
			stroke do
				rectangle [x, cursor - 4], width, width
			end
			x += width + h_margin / 2

			# Quantity
			width = 30
			if item.quantity > 1
				text_box "#{item.quantity}", at: [x, cursor - 5], width: width, single_line: true, align: :right, size: 12
			end
			x += width + h_margin * 3

			# Name and description
			width = 420
			width -= (50 + h_margin) if item.quantity != 1
			text_box item.name, at: [x, cursor], width: width, single_line: true, style: :bold
			text_box item.description, at: [x, cursor - 13], width: width, size: 10, single_line: true
			x += width + h_margin

			# Unit weight
			if item.quantity != 1
				width = 50
				text_box "#{item.weight.grams.round(2)} g", at: [x, cursor - 13], width: width, single_line: true, size: 10, align: :right
				x += width + h_margin
			end

			# Total weight
			width = 50
			text_box "#{item.total_weight.grams.round(2)} g", at: [x, cursor - 13], width: width, single_line: true, size: 10, align: :right
			x += width + h_margin

			move_down 25
			hr 0.5
		end

		def hr(width=1, pad=4)
			old_width, self.line_width = self.line_width, width
			pad_bottom(pad) { stroke_horizontal_rule }
			self.line_width = old_width
		end
	end
end