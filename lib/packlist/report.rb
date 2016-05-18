require 'packlist/model'
require 'packlist/utils'
require 'packlist/template'

module PackList
  class Report
    include GemUtils

    def initialize(packlist)
      @packlist = packlist
          @template = Template.new templates_path('packlist'), 'report'
    end

    def save_to(filename)
      @template.render_to filename, {packlist: @packlist}
    end
  end
end