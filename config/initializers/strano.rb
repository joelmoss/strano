require "github"
require "strano"

config_file = Rails.root.join("config", "strano.yml")
unless config_file.file?

  Strano.configure do |config|
    Strano::Configuration::VALID_OPTIONS_KEYS.each do |k|
      config.send :"#{k}=", ENV["STRANO_#{k.upcase}"] if ENV.has_key?("STRANO_#{k.upcase}")
    end
  end

else
  
  settings = YAML.load(ERB.new(config_file.read).result)[Rails.env]  
  if settings.present?
    Strano.configure do |config|
      Strano::Configuration::VALID_OPTIONS_KEYS.each do |k|
        if settings.has_key?(k)
          config.send :"#{k}=", settings[k]
        elsif ENV.has_key?("STRANO_#{k.upcase}")
          config.send :"#{k}=", ENV["STRANO_#{k.upcase}"]
        end
      end
    end
  end
  
end