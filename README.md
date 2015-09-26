# Nakal

Automated visual testing of Android/iOS applications.

Nakal is used to add visual validations in your existing test framework (using appium or calabash etc).

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

If You want to organize baseline nicely, you can even specify sub-paths in #nakal_execute like this:

	diff_metric = nakal_execute("feature/sub_feature/current_screen_name")

For setting custom directory, use:  

	Nakal.directory= "<desired_directory>"
	Nakal.device_name = "nexus7"

For cropping the notification bar OR scroll bar, create a config/nakal.yml file in execution directory.

eg:

put these contents in your nakal.yml file inside config/nakal.yml

	samsung_galaxy_s3:
	 top: 50
	 right: 18
	 left: 0
	 bottom: 0
	 screen_name_to_be_masked: {mask_region: [66,424,340,478]}
	 feature/sub_feature/current_screen_name: {mask_region_1: [66,424,340,478],mask_region_2: [76,524,440,578]}

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
	 screen_name_to_be_masked: {mask_region: [66,424,340,478]}
     feature/sub_feature/current_screen_name: {mask_region_1: [66,424,340,478],mask_region_2: [76,524,440,578]}
	 
## Note
1. There is implicit wait of 30 sec until current screen matches baseline. This timeout can be changed by setting:


	Nakal.Timeout = new_timeout.


2. you can specify the areas of a screen you want to mask/ignore while comparing in nakal.yml as below:

		samsung_galaxy_s3:
		 top: 50
		 right: 18
		 left: 0
		 bottom: 0
		 screen_name_to_be_masked: {mask_region_1: [66,424,340,478],mask_region_2: [76,524,440,578]}

	 
## Contributing

1. Fork it ( http://github.com/<my-github-username>/nakal/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
