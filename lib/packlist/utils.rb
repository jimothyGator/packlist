module PackList
  module GemUtils
    def gem_path(gem)
      Gem::Specification.find_by_name(gem).gem_dir
    end

    def assets_path(gem, asset_type)
      File.join(gem_path(gem), 'app', 'assets', asset_type)
    end


    def stylesheets_path(gem)
      assets_path(gem, 'stylesheets')
    end

    def templates_path(gem)
      assets_path(gem, 'templates')
    end     
  end
end
