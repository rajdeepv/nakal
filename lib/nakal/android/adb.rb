module Nakal
  module Android
    class ADB
      class << self
        attr_accessor :connected_devices

        def connected_devices
          @connected_devices ||= `adb devices`.scan(/\n(.*)\t/).flatten
        end

        def first_device
          connected_devices.first
        end

        def multiple_devices_connected?
          connected_devices.size > 1
        end

      end
    end
  end
end
