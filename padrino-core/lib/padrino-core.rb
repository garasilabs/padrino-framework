require 'sinatra/base'
Dir[File.dirname(__FILE__) + '/padrino-core/*.rb'].each {|file| require file }

# Defines our PADRINO_ENV
PADRINO_ENV = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development" unless defined?(PADRINO_ENV)

module Padrino
  class ApplicationLoadError < RuntimeError; end

  # Helper method for file references.
  #
  # Example:
  #   # Referencing a file in config called settings.yml
  #   Padrino.root("config", "settings.yml")
  #   # returns PADRINO_ROOT + "/config/setting.yml"
  def self.root(*args)
    File.join(PADRINO_ROOT, *args)
  end
  
  # Helper method that return PADRINO_ENV
  def self.env
    PADRINO_ENV
  end

  # Returns the resulting rack builder mapping each 'mounted' application
  def self.application
    raise ApplicationLoadError.new("At least one application must be mounted onto Padrino!") if self.mounted_apps.none?
    builder = Rack::Builder.new
    self.mounted_apps.each { |app| app.map_onto(builder) }
    builder
  end
end
