require 'spec_helper'

describe RubyGeohash do

  describe "creating from geohash string" do
    it "should return 42.6, -5.6 lat, lng for 'ezs42' geohash " do
      ng = RubyGeohash.from_string("ezs42")
      expect(ng.geohash).to eq("ezs42")
      expect(ng.latitude).to be_within(0.1).of(42.6)
      expect(ng.longitude).to be_within(0.1).of(5.6)
    end
  end

  describe "creating from latitude, longitude and accuracy" do
    it "should return 'ezs42' geohash from lat = 42.6, lng = -5.6, accuracy = 5" do
      ng = RubyGeohash.from_lat_lng(42.6, -5.6, 5)
      expect(ng.geohash).to eq("ezs42")
      expect(ng.latitude).to eq(42.6)
      expect(ng.longitude).to eq(-5.6)
    end
  end


end