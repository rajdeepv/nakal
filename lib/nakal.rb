require "nakal/version"
require 'rmagick'
require 'fileutils'
require 'yaml'
require_relative 'nakal/base_screen'
require_relative 'nakal/android/screen'
require_relative 'nakal/ios/screen'

module Nakal

  class<<self
    attr_accessor :device_name, :directory, :platform, :image_location, :img_dir_created, :default_crop_params

    def configure
      yield self
    end

    def create_image_dir
      unless @img_dir_created
        @image_location ||= "#{@directory}/#{@device_name}"
        FileUtils.mkdir_p @image_location unless File.directory?(@image_location)
        @img_dir_created =true
      end
    end

    def current_platform
      Object.const_get("Nakal::#{Nakal.platform.capitalize}")
    end

  end
end

Nakal.configure do |config|
  config.device_name = "default_device"
  config.directory = "baseline_images"
  config.default_crop_params = (YAML.load(File.open './config/nakal.yml') rescue {})
end
