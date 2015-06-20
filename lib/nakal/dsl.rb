require 'nakal'

module Nakal
  module DSL

    def current_screen_vs_base_image image_file_name
      orignal_screen = Nakal.current_platform::Screen.new(image_file_name, :load)
      current_screen = Nakal.current_platform::Screen.new("#{image_file_name}_current", :capture)
      diff_screen, diff_metric = orignal_screen.compare(current_screen)
      diff_metric==0 ? current_screen.delete! : diff_screen.save
      diff_metric
    end

    def capture_screen image_name
      Nakal.current_platform::Screen.new(image_name, :capture)
    end

    def nakal_execute image_name, delay = nil
      return if ENV['NAKAL_MODE'].nil?
      Nakal.create_image_dir
      puts "********* #{delay} *********"
      sleep delay unless delay.nil?
      capture_screen(image_name) if ENV['NAKAL_MODE'] == "build"
      current_screen_vs_base_image(image_name) if ENV['NAKAL_MODE'] == "compare"
    end
  end

end