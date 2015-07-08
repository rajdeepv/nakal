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
        sleep 1
        Dir.glob(File.expand_path('~/Desktop/iOS\\ Simulator\\ Screen\\ Shot - Apple\\ Watch*')).each{|f| FileUtils.rm(f)}
        latest_file = Dir.glob(File.expand_path('~/Desktop/iOS\\ Simulator\\ Screen\\ Shot*')).max_by { |f| File.mtime(f) }
        File.rename(latest_file,"#{Nakal.image_location}/#{@name}.png")
      end

    end
  end
end
