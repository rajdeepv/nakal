# Nakal

Automated visual testing of Android/iOS applications

## Installation
You need to install [imagemagick](http://www.imagemagick.org/script/index.php) on your machine

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
	
	for ios, set:
	
	Nakal.platform = :ios


and then put this line in your automation code, at all places where a new screen loads:

	diff_metric = nakal_execute("current_screen_name")

Now, execute your test by passing env variable NAKAL_MODE=build to build the baseline images. All baseline images will be stored in baseline_images folder in current directory

once baseline is built, next execution onwards, start using environment variable NAKAL_MODE=compare to compare against baseline.
any difference will be put in the same directory with image file named "current_screen_name_diff.png"

## Important

* This works best when your tests are running against mocked data
* If test data keeps changing for each test, use diff_metric (output of nakal_execute method above) to determine if the change is acceptable.

For setting custom directory, use:  

	Nakal.directory= "<desired_directory>"
	Nakal.device_name = "nexus7"

For cropping the notification bar OR scroll bar, create a config/nakal.yml file in execution directory

eg:

put these contents in your nakal.yml file inside config/nakal.yml

	samsung_galaxy_s3:
	 top: 50
	 right: 18
	 left: 0
	 bottom: 0

	nexus7:
	 top: 74
	 right: 20
	 left: 0
	 bottom: 0

	iPhone_5s:
	 top: 30
	 right: 6
	 left: 0
	 bottom: 0  
	 
	 
## Contributing

1. Fork it ( http://github.com/<my-github-username>/nakal/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request