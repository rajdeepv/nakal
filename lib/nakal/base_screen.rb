module Nakal
  module Common
    class BaseScreen

      attr_accessor :image, :name

      def initialize file_name, mode = :load, image = nil
        @name = file_name
        if mode.eql?(:capture)
          capture
          load_image_from_file
        elsif mode.eql?(:load)
          load_image_from_file
        else
          @image=image
        end
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
        diff_img, diff_metric = self.strip.compare_channel(screen.strip, Magick::RootMeanSquaredErrorMetric)
        diff_screen = Nakal.current_platform::Screen.new("#{@name}_diff", :none, diff_img)
        return diff_screen, diff_metric
      end

      def delete!
        FileUtils.rm "#{Nakal.image_location}/#{@name}.png"
      end

      def save
        @image.write("#{Nakal.image_location}/#{@name}.png")
      end

      private

      def load_image_from_file
        @image = Magick::Image.read("#{Nakal.image_location}/#{@name}.png")[0]
      end

    end
  end
end
