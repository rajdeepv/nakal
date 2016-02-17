module Nakal
  module Ios
    class Screen < Common::BaseScreen

      private

      def capture_script
        "osascript <<EOF
        tell application \"#{simulator_app_name}\"
        activate
        delay 0.5
        tell application \"System Events\" to keystroke \"1\" using {command down}
        delay 0.5
        tell application \"System Events\" to keystroke \"s\" using {command down}
        end tell
        EOF"
      end

      def simulator_app_name
        xcode_7 = !(%x(instruments -s devices ; echo)).match(' Simulator\)')
        xcode_7 ? "Simulator" : "iOS Simulator"
      end

      def capture
        `#{capture_script}`
        sleep 1
        Dir.glob(File.expand_path("~/Desktop/#{simulator_app_name}\\ Screen\\ Shot - Apple\\ Watch*")).each { |f| FileUtils.rm(f) }
        latest_file = Dir.glob(File.expand_path("~/Desktop/#{simulator_app_name}\\ Screen\\ Shot*")).max_by { |f| File.mtime(f) }
        File.rename(latest_file, "#{Nakal.image_location}/#{@name}.png")
      end

    end
  end
end