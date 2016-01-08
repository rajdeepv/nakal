require 'rmagick'
require 'fileutils'
require 'yaml'
require 'pry'
require_relative "nakal/version"
require_relative 'nakal/base_screen'
require_relative 'nakal/android/screen'
require_relative 'nakal/ios/screen'
require_relative 'nakal/dsl'

module Nakal

  class<<self
    attr_accessor :device_name, :directory, :platform, :image_location, :default_crop_params
    attr_accessor :diff_screens, :embed_screenshot, :timeout, :image_relative_dir, :fuzz, :config_location

    def configure
      yield self
    end

    def create_image_dir image_relative_dir
      @image_relative_dir = image_relative_dir
      @image_location = "#{@directory}/#{@device_name}/#{image_relative_dir}"
      FileUtils.mkdir_p @image_location unless File.directory?(@image_location)
    end

    def load_config
      @default_crop_params ||= YAML.load(File.open Nakal.config_location)
    end

    def set relative_location
      create_image_dir relative_location
      load_config
    end

    def current_platform
      Nakal.const_get Nakal.platform.capitalize
    end

  end
end

Nakal.configure do |config|
  config.device_name = "default_device"
  config.directory = "baseline_images"
  config.config_location = "./config/nakal.yml"
  config.embed_screenshot = false
  config.diff_screens = []
  config.timeout = 30
  config.fuzz = 10
end
