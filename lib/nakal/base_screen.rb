module Nakal
  module Common
    class BaseScreen

      attr_accessor :image, :name

      def initialize file_name, mode = :load, image = nil
        @name = file_name
        @image = image
        capture if mode.eql?(:capture)
        image.nil? ? @image = Magick::Image.read("#{Nakal.image_location}/#{@name}.png")[0] : @image=image
      end

      def strip
        crop_params = Nakal.default_crop_params[Nakal.device_name]
        if crop_params.nil?
          @image
        else
          width = @image.columns
          height = @image.rows
          x_start = crop_params["left"]
          y_start = crop_params["top"]
          width_to_consider = width-crop_params["right"]-x_start
          height_to_consider = height-crop_params["bottom"]-y_start
          @image.crop(x_start, y_start, width_to_consider, height_to_consider)
        end
      end

      def compare screen
        @image.fuzz= Nakal.fuzz * Magick::QuantumRange / 100.0
        total_pixel = @image.rows * @image.columns
        diff_img, no_of_pixels_mismatch = self.apply_mask.strip.compare_channel(screen.apply_mask.strip, Magick::AbsoluteErrorMetric)
        diff_screen = Nakal.current_platform::Screen.new("#{@name}_diff", :none, diff_img)
        percentage_diff = (no_of_pixels_mismatch/total_pixel)*100
        return diff_screen,percentage_diff
      end

      def apply_mask
        image_mask_params = Nakal.default_crop_params[Nakal.device_name][image_relative_path.gsub("_current", "")]
        return self if image_mask_params.nil?
        image_mask_params.each do |region, params|
          gc = Magick::Draw.new.fill('black').rectangle(*params)
          gc.draw @image
        end
        self
      end

      def image_relative_path
        Nakal.image_relative_dir.eql?(".") ? @name : "#{Nakal.image_relative_dir}/#{@name}"
      end

      def delete!
        FileUtils.rm "#{Nakal.image_location}/#{@name}.png"
      end

      def save
        @image.write("#{Nakal.image_location}/#{@name}.png")
      end

    end
  end
end
