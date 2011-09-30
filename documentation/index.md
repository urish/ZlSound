# ZLSound Module

## Description

The ZLSound module allows you to play sounds with minimal (unnoticeable) latency. You can also set looping points, control volume, change pitch and pan.

## Important NOTICE

Use real devices when testing your applications. The simulator is no substitute for the real thing. In our some of our tests, the simulator had clicks and cracks in the sound, while the real device always played the sounds smoothly.

If you don't have an apple developer license yet, and you want to experience the performance of this module on
a real device, you can download our [Free Pan-Flute Application](http://itunes.apple.com/us/app/zampona/id448009267?mt=8) from the App Store.

## Android version

An android version is currently not available. If there will be enough community interest, however, we will
definitely create an android version as well. If you are interested in an android version, please leave a 
comment on the Appcelerator Mobile Marketplace page for this product and cast your vote.

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