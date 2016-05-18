require 'padrino-helpers'
require 'sinatra'

module PackList
    class Template
        include Sinatra::Templates
        include Padrino::Rendering
        include Padrino::Helpers::RenderHelpers
        attr_reader :template_cache


        def initialize(templates_path, template_file_name)
            @template_cache = Tilt::Cache.new
            @template_file_name = template_file_name
            settings.views = templates_path
        end

        def render_to(filename, data)
            File.open(filename, 'w') do |file|
                content = render(@template_file_name, locals: data)
                file.write(content)
            end
        end

        def settings
            self.class
        end

        ##
        # Returns true if the templates will be reloaded; false otherwise.
        #
        def self.reload_templates?
          true
        end

        ##
        # Sets the message defined template path to the given view path.
        #
        def self.views=(value)
          @_views = value
        end

        ##
        # Returns the template view path defined for this message.
        #
        def self.views
          @_views
        end

        ##
        # Sinatra almost compatibility.
        #
        def self.set(name, value)
          self.class.instance_eval{ define_method(name) { value } unless method_defined?(:erb) }
        end

        ##
        # Return the default encoding.
        #
        def self.default_encoding
          "utf-8"
        end

        def self.templates
          {}
        end
    end
end