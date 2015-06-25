module Nakal
  module Ios
    class Screen < Common::BaseScreen

      private

      CAPTURE_SCRIPT = 'osascript <<EOF
      tell application "iOS Simulator"
      activate
      delay 1
      tell application "System Events" to keystroke "s" using {command down}
      end tell
      EOF'

      def capture
        `#{CAPTURE_SCRIPT}`
        sleep 0.5
        latest_file = Dir.glob(File.expand_path('~/Desktop/iOS\\ Simulator\\ Screen\\ Shot*')).max_by { |f| File.mtime(f) }
        `mv  #{Shellwords.shellescape(latest_file)} #{Nakal.image_location}`
        `mv #{Nakal.image_location}/iOS\\ Simulator\\ Screen\\ Shot* #{Nakal.image_location}/#{@name}.png`
      end

    end
  end
end
