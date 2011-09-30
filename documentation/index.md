# ZLSound Module

## Description

The ZLSound module allows you to play sounds with minimal (unnoticeable) latency. You can also set looping points, control volume, change pitch and pan.

## Accessing the ZLSound Module

To access this module from JavaScript, you would do the following:

	var ZLSound = require("com.salsarhythmsoftware.zlsound");

The ZLSound variable is a reference to the Module object.	

### createSample(properties[dict])

Creates a new sound sample for instant playback. Takes one optional argument, a dictionary with
the properties defined in <em>[ZLSound.Sample](Sample.html)</em>.

Returns a <em>[ZLSound.Sample](Sample.html)</em> object.

## Usage

See the provided example application (under example/app.js).

## Author

Uri Shaked, [uri@salsa4fun.co.il](mailto:uri@salsa4fun.co.il)

## License

Copyright(c) 2011 by Uri Shaked. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.