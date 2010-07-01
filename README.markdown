= StaticGmaps

== DESCRIPTION:

Provides an interface to the Google Static Maps API.
Original Version from John Wulff.  Contributors include Daniel Mattes, Nat Lownes.

== FEATURES/PROBLEMS:

* Provides an interface to the Google Static Maps API.

== SYNOPSIS:

In environment.rb or initializers you can set default values, for example:

	StaticGmaps::default_size = [ 170, 200 ]

	map = StaticGmaps::Map.new :center   => [ 40.714728, -73.998672 ],
	                            :zoom     => 5,
	                            :size     => [ 500, 400 ],
	                            :map_type => :roadmap

	map.markers << StaticGmaps::Marker.new(:latitude => 40,
	                                        :longitude => -73,
	                                        :color => :blue,
	                                        :label => "B")
map.url => 'http://maps.google.com/maps/api/staticmap?center=40.714728,-73.998672&map_type=roadmap&markers=color:blue|label:B|40,-73&sensor=false&size=500x400&zoom=5'

Both Map and Marker can also use an address instead of coordinates in an array.  Example:

	map = StaticGmaps::Map.new do |m|
		m.center = "1234 Market St.; Phila, PA"
		m.zoom	 = 13
	end

	map.markers << StaticGmaps::Marker.new do |m|
		m.location = "412 W. Girard Ave; Phila, PA"
		m.color    = "yellow"
		m.label    = "F"
	end

	map.markers << StaticGmaps::Marker.new do |m|
		m.location = "1356 N. Front St; Phila, PA"
		m.color    = "orange"
		m.label    = "E"
	end

== REQUIREMENTS:

* None.

== INSTALL:

* sudo gem install static-gmaps

== LICENSE:

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
