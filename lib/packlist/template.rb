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
        file.write(generate data)
      end
    end

    def generate(data)
      render(@template_file_name, locals: data)
    end

    def settings
      self.class
    end

    def self.reload_templates?
      true
    end

    def self.views=(value)
      @_views = value
    end

    def self.views
      @_views
    end

    def self.set(name, value)
      self.class.instance_eval{ define_method(name) { value } unless method_defined?(:erb) }
    end

    def self.default_encoding
      "utf-8"
    end

    def self.templates
      {}
    end
  end
end