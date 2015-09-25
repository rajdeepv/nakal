require 'spec_helper'
require 'nakal'

`rm -rf spec/resources/droid`
Nakal.platform = :android
Nakal.directory= "spec/resources/droid"
Nakal.device_name = "samsung_galaxy_s3"
Nakal.create_image_dir "xx"

module Nakal::Android
  class Screen
    def capture
      `cp spec/resources/*.png #{Nakal.image_location}`
    end
  end
end

describe Nakal::Android::Screen do

  before(:all) do
    @screen = Nakal::Android::Screen.new("home_screen", :capture)
  end

  describe "#new" do
    it "creates new screen by capturing it" do
      expect(@screen).to be_an_instance_of Nakal::Android::Screen
    end

    it "creates new screen object using an image file" do
      new_screen = Nakal::Android::Screen.new("home_screen", :load)
      expect(new_screen.name).to eq "home_screen"
      expect(new_screen.image).to be_an_instance_of Magick::Image
    end

    it "throws error if new screen is created using invalid file" do
      expect { Nakal::Android::Screen.new("invalid_image", :load) }.to raise_error(Magick::ImageMagickError)
    end
  end

  describe "#strip" do
    it "does not crop image when no params are given" do
      Nakal.default_crop_params = {}
      expect(@screen.strip.rows).to eq 1280
      expect(@screen.strip.columns).to eq 720
    end

    it "crops the image as per nakal.yml params" do
      Nakal.default_crop_params = {"samsung_galaxy_s3" => {"top" => 50, "right" => 18, "left" => 12, "bottom" => 15},
                                   "nexus7" => {"top" => 74, "right" => 20, "left" => 0, "bottom" => 0}}

      device_params = Nakal.default_crop_params[Nakal.device_name]
      expected_rows = @screen.image.rows - device_params["top"] - device_params["bottom"]
      expected_columns = @screen.image.columns - device_params["left"] - device_params["right"]
      expect(@screen.strip.rows).to eq (expected_rows)
      expect(@screen.strip.columns).to eq (expected_columns)
    end
  end

  describe "#save,#delete" do
    it "can create,save and delete a screen using image object" do
      Nakal.default_crop_params = {"samsung_galaxy_s3" => {"top" => 450, "right" => 180, "left" => 12, "bottom" => 15}}
      image = @screen.strip
      new_screen = Nakal::Android::Screen.new("new_home_screen", nil, image)
      new_screen.save
      expect(File.exist?("#{Nakal.image_location}/new_home_screen.png")).to eq true
      new_screen.delete!
      expect(File.exist?("#{Nakal.image_location}/new_home_screen.png")).to eq false
    end
  end

  describe "#compare" do
    it "compares two screens" do
      Nakal.default_crop_params = {"samsung_galaxy_s3" => {"top" => 50, "right" => 0, "left" => 0, "bottom" => 0}}
      changed_screen = Nakal::Android::Screen.new("home_screen_current", :load)
      diff_screen, diff_metric = @screen.compare(changed_screen)
      expect(diff_metric.round(6)).to eq 0.062555
      expect(diff_screen).to be_an_instance_of Nakal::Android::Screen
      expect(diff_screen.name).to eql "home_screen_diff"
      diff_screen.save
    end

    it "compares two screens by ignoring specified region" do
      Nakal.default_crop_params = {"samsung_galaxy_s3" => {"top" => 50, "right" => 0, "left" => 0, "bottom" => 0,
                                                           "home_screen" => {"cam_icon1" => [66, 852, 206, 996]}}}
      @screen = Nakal::Android::Screen.new("home_screen", :load)
      changed_screen = Nakal::Android::Screen.new("home_screen_current", :capture)
      diff_screen, diff_metric = @screen.compare(changed_screen)
      expect(diff_metric.round(5)).to eq 0.05189
      diff_screen.save
    end

    it "compares two screens by ignoring all specified region" do
      Nakal.default_crop_params = {"samsung_galaxy_s3" => {"top" => 50, "right" => 0, "left" => 0, "bottom" => 0,
                                                           "home_screen" => {"cam_icon1" => [66, 852, 206, 996], "cam_icon2" => [210, 228, 340, 392],"clock" => [364, 484, 672, 770]}}}
      @screen = Nakal::Android::Screen.new("home_screen", :load)
      changed_screen = Nakal::Android::Screen.new("home_screen_current", :capture)
      diff_screen, diff_metric = @screen.compare(changed_screen)
      expect(diff_metric).to eq 0.0
      diff_screen.save
    end
  end

  after(:all) do
    `rm -rf #{Nakal.image_location}/*.png`
  end
end