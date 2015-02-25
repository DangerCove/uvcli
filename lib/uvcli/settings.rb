require "yaml"
require "uvcli/version"

module Uvcli
  class Settings
  
    SETTINGS_FOLDER = File.expand_path("~/.uvcli")
    SETTINGS_PATH = "#{SETTINGS_FOLDER}/uvcli.yml"

    def initialize
      load_values
    end

    def sites
      @values['sites']
    end

    def add_site?(domain, key, secret)
      @values['sites'] << { "domain" => domain, "key" => key, "secret" => secret }
      store?
    end

    def store?

      file, settings = nil
      if has_stored_settings?
        settings = @values
        file = File.open(SETTINGS_PATH, 'w')
      else 
        FileUtils.mkdir_p(SETTINGS_FOLDER)
        file = File.new(SETTINGS_PATH, 'w')
        settings = { "version" => Uvcli::VERSION, "sites" => [] }
      end

      if file
        file.puts(settings.to_yaml)
        file.close
        return true
      end

      false
    end

    private

    def has_stored_settings?
      File.exists?(File.expand_path(SETTINGS_PATH))
    end

    def load_values
      
      store? unless has_stored_settings?

      @values = YAML.load_file(SETTINGS_PATH)
    end
  end
end
