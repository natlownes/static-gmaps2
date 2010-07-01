require 'rubygems'
require 'spec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'static_gmaps')
include StaticGmaps

STATIC_GOOGLE_MAP_DEFAULT_PARAMETERS_TEST_IMAGE_PATH = File.join File.dirname(__FILE__), 'test_image.gif'

describe StaticGmaps do
  describe Map do
    context "initializing with empty attributes" do
      before(:each) do 
        @map = StaticGmaps::Map.new 
      end
    
      #it 'should set center to default'   do @map.center.should   == StaticGmaps::default_center end
      # no default center, because of auto adjustment
      it 'should set zoom to default' do
        @map.zoom.should     == StaticGmaps::default_zoom
      end
      it 'should set size to default' do
        @map.size.should     == StaticGmaps::default_size
      end
      it 'should set map_type to default' do
        @map.map_type.should == StaticGmaps::default_map_type
      end
      it 'should not set key if not provided' do
        @map.key.should be_nil
      end
    end # initialize without attr
    
    context 'initializing with all attributes' do
      before(:each) do
        @marker = StaticGmaps::Marker.new :latitude => 0, :longitude => 0
        @map = StaticGmaps::Map.new :center   => [ 40.714728, -73.998672 ],
                                    :zoom     => 12,
                                    :size     => [ 500, 400 ],
                                    :map_type => :roadmap,
                                    :key      => 'ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA',
                                    :markers  => [ @marker ]
      end
      
      it 'should set center' do 
        @map.center.should   == [ 40.714728, -73.998672 ] 
      end
      it 'should set zoom' do 
        @map.zoom.should     == 12 
      end
      it 'should set size' do 
        @map.size.should     == [ 500, 400 ] 
      end
      it 'should set map_type' do 
        @map.map_type.should == :roadmap 
      end
      it 'should set key if provided' do 
        @map.key.should      == 'ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA' 
      end
      it 'should set markers'  do 
        @map.markers.should  == [ @marker ] 
      end
      
    end#initialize w/all attrs
    
    context 'with default attributes' do
      before(:each) do
        @map = StaticGmaps::Map.new
      end

      it 'should have a url' do
        @map.url.should == "#{StaticGmaps.base_uri}?center=0,0&map_type=roadmap&sensor=false&size=500x400&zoom=1"
      end
      
      it 'should have a width' do
        @map.width.should    == 500
      end
      
      it 'should have a height' do
        @map.height.should   == 400
      end
      
      it 'should set sensor attribute to false' do
        @map.sensor.should be_false
      end
    end
    
    context 'with default attributes and markers' do
      before(:each) do
        @marker_1 = StaticGmaps::Marker.new :latitude => 10, :longitude => 20, :color => 'green', :label => 'A'
        @marker_2 = StaticGmaps::Marker.new :latitude => 15, :longitude => 25, :color => 'blue', :label => 'B'
        @map = StaticGmaps::Map.new :markers  => [ @marker_1, @marker_2 ]
      end
      
      it 'should have a markers_url_fragment' do 
        # the first "markers" parameter for multiple markers will be added on in Map#url
        @map.markers_url_fragment.should match(/color:green/)
        @map.markers_url_fragment.should match(/color:blue/)
        @map.markers_url_fragment.should match(/label:A/)
        @map.markers_url_fragment.should match(/label:B/)
        @map.markers_url_fragment.should match(/10,20/)
        @map.markers_url_fragment.should match(/15,25/)
      end
      
      it 'should include the markers_url_fragment its url' do 
        @map.url.should include(@map.markers_url_fragment) 
      end
    end
  end #describe Map
  
  describe Marker do 
    context 'initializing with no attributes' do
      before(:each) do 
        @marker = StaticGmaps::Marker.new
      end
      it 'should set latitude to default' do 
        @marker.latitude.should        == StaticGmaps::default_latitude 
      end
      it 'should set longitude to default' do
        @marker.longitude.should       == StaticGmaps::default_longitude
      end
      it 'should set color to default'           do
        @marker.color.should           == StaticGmaps::default_color
      end
      it 'should set alpha_character to default' do 
        @marker.label.should == StaticGmaps::default_alpha_character
      end
    end
    
    context 'initialize with all attributes' do
      before(:each) do
        @marker = StaticGmaps::Marker.new :latitude => 12,
                                          :longitude => 34,
                                          :color => 'red',
                                          :alpha_character => 'z'
      end
      
      it 'should set latitude' do 
        @marker.latitude.should        == 12
      end
      
      it 'should set longitude' do
        @marker.longitude.should       == 34
      end
      
      it 'should set color' do
        @marker.color.should           == :red
      end
      
      it 'should set alpha_character' do 
        @marker.alpha_character.should == "Z"
      end
    end
    
    context 'initialize with address as location' do
      before :each do
        @address = '1234 Market St. Philadelphia, PA'
        @marker = Marker.new do |m|
          m.location = @address
        end
      end
      
      it 'should return a uri encoded address for location' do
        @marker.location.should == URI.encode(@address)
      end
      
      it 'should return nil for latitude' do
        @marker.latitude.should be_nil
      end
      
      it 'should return nil for longitude' do
        @marker.longitude.should be_nil
      end
    end
    
    context 'url_fragment ordering' do
      before :each do
        @address = '1234 Market St. Philadelphia, PA'
        @marker = Marker.new do |m|
          m.location = @address
          m.color = "red"
          m.label = 1
        end
      end
      
      it 'should end with the address/coordinates' do
        @marker.url_fragment.should match /.PA$/
      end
    end
    
    context "using a custom icon" do
      before :each do
        @uri = 'http://chart.apis.google.com/chart?chst=d_map_pin_icon&chld=home|FFFF00'
        @marker = Marker.new do |m|
          m.location = [40.000, -33.000]
          m.icon = @uri
        end
      end
      
      it 'should also encode |, &, and ?' do
        @marker.icon.should == 'http://chart.apis.google.com/chart%3Fchst=d_map_pin_icon%26chld=home%7CFFFF00'
      end
      
    end
    
  end #Marker
  
  describe Location do
    before(:each) do
      @coordinates = [39.967648,-75.156784]
      @address = '1234 Market St. Philadelphia, PA'
    end
    
    it 'should initialize with either an array or a string' do
      lambda {
        Location.new(@coordinates)
      }.should_not raise_error
      
      lambda {
        Location.new(@address)
      }.should_not raise_error
    end
    
    it 'should URI.encode an address string' do
      Location.new(@address).value.should == URI.encode(@address)
    end
    
    it 'should return either array of coordinates or address with Location#value()' do
      Location.new(@coordinates).value.should == @coordinates
    end
  
  end #describe Location
end #describe StaticGmaps