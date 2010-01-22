require 'yaml'
require 'facets/string'
require 'facets/hash'

module Configurize
  def [](key)
    config[key.to_sym]
  end

  def []=(key, value) 
    config[key.to_sym] = value
    write_config
  end

  def config
    @config ||= load_config
  end

  def to_s
    "#{self.name}: #{printable_config}"
  end

  private

  def printable_config
    array = []
    config.each {|k,v| array << ":#{k} => \'#{v}\'" }
    array.join(", ")
  end

  def config_file_path
    if defined?(Rails)
      File.expand_path(Rails.root + "/config/#{config_file_name}")
    else
      File.expand_path(__FILE__ + "/../../config/#{config_file_name}")
    end
  end

  def config_file_name
    "#{self.name.underscore}.yml"
  end

  def load_config
    if File.exists?(config_file_path)
      YAML.load_file(config_file_path).symbolize_keys
    else
      {}
    end
  end

  def write_config
    File.open(config_file_path, "w") do |file|
      YAML.dump(config.stringify_keys, file)
    end
  end

end
