require "RubyGeohash/version"

class Array
  def odd_values
    self.values_at(* self.each_index.select { |i| i.odd? })
  end

  def even_values
    self.values_at(* self.each_index.select { |i| i.even? })
  end
end

class RubyGeohash

  @@BASE_32_CHARS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'b', 'c', 'd', 'e', 'f',
                     'g', 'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

  attr_reader :latitude, :longitude, :geohash

  def initialize(latitude, longitude, geohash)
    @latitude = latitude
    @longitude = longitude
    @geohash = geohash
  end

  def self.from_string(geohash)
    # TODO: validate if is base32
    lat_range = [-90, 90]
    lng_range = [-180, 180]
    binary = geohash.chars.map { |char| format("%05b", @@BASE_32_CHARS.index(char)) }
                 .inject("") { |totalBits, bits| totalBits << bits }

    lng_code, lat_code = binary.chars.even_values, binary.chars.odd_values

    lat_code.each do |bit|
      mid = (lat_range[0] + lat_range[1]) / 2.0
      sub_i = bit == "1" ? 0 : 1
      lat_range[sub_i] = mid
    end

    lng_code.each do |bit|
      mid = (lng_range[0] + lng_range[1]) / 2.0
      sub_i = bit == "1" ? 1 : 0
      lng_range[sub_i] = mid
    end

    lat = (lat_range[0] + lat_range[1]) / 2.0
    lng = (lng_range[0] + lng_range[1]) / 2.0

    RubyGeohash.new(lat, lng, geohash)
  end

  def self.from_lat_lng(lat, lng, accuracy = 12)
    lat_range = [-90, 90]
    lon_range = [-180, 180]
    idx = 0
    bit = 0
    is_even = true
    geohash = ""
    while geohash.size < accuracy
      if is_even
        lon_mid = (lon_range[0] + lon_range[1]) / 2.0
        if lng > lon_mid
          idx = idx*2 + 1
          lon_range[0] = lon_mid
        else
          idx = idx * 2
          lon_range[1] = lon_mid
        end
      else
        lat_mid = (lat_range[0] + lat_range[1]) / 2.0
        if lat > lat_mid
          idx = idx * 2 + 1
          lat_range[0] = lat_mid
        else
          idx = idx * 2
          lat_range[1] = lat_mid
        end
      end
      is_even = !is_even
      bit += 1
      if bit == 5
        geohash << @@BASE_32_CHARS[idx]
        bit = 0
        idx = 0
      end
    end
    RubyGeohash.new(lat, lng, geohash)
  end

end