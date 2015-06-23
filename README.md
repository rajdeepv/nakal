# Nakal

Automated visual testing of Android/iOS applications

## Installation

Add this line to your application's Gemfile:

    gem 'nakal'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nakal

## Usage

If you are using cucumber, include following Lines in your env.rb

require "nakal/cucumber"

Nakal.platform = :android

Nakal.directory= "baseline_images/droid"

Nakal.device_name = "samsung_galaxy_s3"

and then put this line in your code where you want comparison to begin:

nakal_execute("current_screen_name")


While executing, pass env variable NAKAL_MODE=build to build the baseline images

once baseline is built, next execution onwards, start using environment variable NAKAL_MODE=compare to compare against baseline

This is currently beta and implemented for android only. iOs is work in progress

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nakal/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
