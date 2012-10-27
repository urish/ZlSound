# ZLSound.Sample

## Description

A ZLSound module object which represents a single sound sample. Sound samples are preloaded into memory in order
to allow instant playback. They can also be looped by setting the <em>loopIn</em> and <em>loopOut</em> properties.

## Functions

### play()

Plays the sound sample instantly. You must set the 'media' property prior to calling this method.

### loop(timesToRepeat[int])

Plays the sound sample, looping it <em>timesToRepeat</em> times after the inital playback. Note 
that <em>timesToRepeat</em> can be set to large values (1000 or more) without any worries, as the
function uses an efficient method to achieve seemless looping. You can stop the looping sound at
any time by calling the stop() method.

Note: You must set the 'media' property prior to calling this method.

### stop()

Stops the currently playing sound.

## Properties

### media[string]

Sets the name of the WAVE file to play. Setting this property actually loads the file into memory and prepares the sound buffer for playback. It does not play the file. Note that changing this property may clear the looping points.

### loopIn[int]

Cues the loop-in point of the sample. The value is expressed in number of audio frames, so if your sample is using 44100hz sampling rate, for example, setting this property 22050 will cue the loop-out point to second 0.5. Changing
the value of this property has no effect on the currently playing sound, it will only affect subsequent calls to
the loop() method.

### loopOut[int]

Cues the loop-out point of the sample. The value is expressed in number of audio frames, so if your sample is using 44100hz sampling rate, for example, setting this property 88200 will cue the loop-out point to second 2.0. Changing
the value of this property has no effect on the currently playing sound, it will only affect subsequent calls to
the loop() method.

### pan[float]

Controls the panning of the sample. A value of 0.0 will center the sample, -1.0 is far left and 
1.0 is far right. Note that stereo samples do not support panning.

### pitch[float]

Controls the pitch of the sample. A value of 1.0 will leave the pitch unchanged. The sample will
play faster and with an increased pitch for greater values, and slower with a lower pitch for
smaller values.

Examples: a value of 2.0 will play the sample twice the original speed with a pitch two times
higher, which a value of 0.5 will play the sample half the original speed with a lower pitch.

### playing[boolean] (read-only)

True if the sound sample is currently playing.

### volume[float]

Controls the volume of the sample. The valid values are in the range [0, 1.0], where higher values represent
a higher volume.

### duration[float] (read-only)

Returns the duration of the media in seconds.

## Author

Uri Shaked, [uri@salsa4fun.co.il](mailto:uri@salsa4fun.co.il)

## License

Copyright(c) 2011 by Uri Shaked. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.