require_relative 'adb'
module Nakal
  module Android
    class Screen < Common::BaseScreen

      private

      def capture
        device_arg = ADB.multiple_devices_connected? ? "-s #{ENV['ADB_DEVICE_ARG']}" : ""
        `adb #{device_arg} shell  screencap -p /sdcard/#{@name}.png`
        `adb #{device_arg} pull /sdcard/#{@name}.png #{Nakal.image_location}`
      end

    end
  end
end