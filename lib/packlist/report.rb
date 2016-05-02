require 'packlist/model'
require 'packlist/utils'
require 'erubis'
require 'sass'

module PackList
	class Report
		include ::PackList::GemUtils

		def initialize(packlist)
			@packlist = packlist

			template_path = File.join(templates_path('packlist'), 'report.html.erb')
			input = File.read(template_path)
			@template = Erubis::Eruby.new(input)    # create Eruby object
		end

		def save_to(filename)
			css = read_stylesheet

			context = {packlist: @packlist, styles: css, category_lists: [@packlist.categories]}

			File.open(filename, 'w') do |file|
				file.write(@template.result(context))
			end
		end

		private

		def split_categories
			categories = @packlist.categories.sort_by { |x| 0 - x.items.length }
			cats1 = []
			cats2 = []
			count1 = 0
			count2 = 0
			categories.each do |cat|
				if count2 < count1
					cats2 << cat
					count2 += cat.items.length + 2
				else
					cats1 << cat
					count1 += cat.items.length + 2
				end
			end

			category_lists = [cats1, cats2]
			category_lists.each do |categories|
				categories.sort_by! { |x| @packlist.categories.index(x) }
			end

			category_lists
		end

		def read_stylesheet
			sass_options = {
				syntax: :scss,
				load_paths: [
					stylesheets_path("packlist"),
				]
			}
			template_path = File.join(stylesheets_path('packlist'), 'styles.scss')
			template = File.read(template_path)
			sass_engine = Sass::Engine.new(template, sass_options)
			sass_engine.render
		end
	end


end