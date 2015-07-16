require_relative '../nakal'
require 'timeout'

module Nakal
  module DSL

    def current_screen_vs_base_image image_file_name
      orignal_screen = Nakal.current_platform::Screen.new(image_file_name, :load)
      current_screen = Nakal.current_platform::Screen.new("#{image_file_name}_current", :capture)
      diff_screen, diff_metric = orignal_screen.compare(current_screen)

      Timeout::timeout(Nakal.timeout) {
        until diff_metric < 0.05 do
          sleep 1
          current_screen = Nakal.current_platform::Screen.new("#{image_file_name}_current", :capture)
          diff_screen, diff_metric = orignal_screen.compare(current_screen)
        end
      } rescue nil

      if diff_metric==0
        current_screen.delete!
      else
        diff_screen.save
        Nakal.diff_screens << image_file_name
        embed_screenshots image_file_name if Nakal.embed_screenshot == true
      end
      diff_metric
    end

    def embed_screenshots image_file_name
      embed("#{image_file_name}.png", 'image/png', "#{image_file_name}")
      embed("#{image_file_name}_current.png", 'image/png', "#{image_file_name}_current")
      embed("#{image_file_name}_diff.png", 'image/png', "#{image_file_name}_diff")
    end

    def capture_screen image_name
      Nakal.current_platform::Screen.new(image_name, :capture)
    end

    def nakal_execute image_name, params = {:delay => nil, :replace_baseline => false}
      return if ENV['NAKAL_MODE'].nil?
      sleep params[:delay] unless params[:delay].nil?
      capture_screen(image_name) if (ENV['NAKAL_MODE'] == "build") || (params[:replace_baseline] == true)
      current_screen_vs_base_image(image_name) if ENV['NAKAL_MODE'] == "compare" && params[:replace_baseline] != true
    end
  end

end