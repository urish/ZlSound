//
//  ComSalsarhythmsoftwareZlsoundSampleProxy.m
//  alsound
//
//  Created by uri on 7/9/11.
//  Copyright 2011 Uri Shaked. All rights reserved.
//

#import "ComSalsarhythmsoftwareZlsoundSampleProxy.h"
#import "TiUtils.h"

#define LOOP_REPEAT_TIMES (255)

@implementation ComSalsarhythmsoftwareZlsoundSampleProxy


@synthesize source = _source;
@synthesize mainBuffer = _mainBuffer;
@synthesize beginBuffer = _beginBuffer;
@synthesize loopBuffer = _loopBuffer;

-(id)initWithSourcePool: (ALSoundSourcePool*)pool andArgs:(id)args {
    if ((self = [super init])) {
        self->sourcePool = [pool retain];
        self->pitch = 1.0f;
		self->volume = 1.0f;
		self->pan = 0.0f;
        self->reverbLevel = 0.5f;
        self->media = nil;
        self.source = nil;
        self.mainBuffer = nil;
        self.beginBuffer = nil;
        self.loopBuffer = nil;
        NSDictionary *properties = nil;
        if ([args count] > 0 && [[args objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
            properties = (NSDictionary*)[args objectAtIndex:0];
        }
        [self _initWithProperties:properties];
    }
    
    return self;
}

#pragma mark PRIVATE

- (ALSource*)obtainSource {
    ALSource *result = (ALSource*)[sourcePool getFreeSource:NO];

    /* Sometimes OpenAL does not stop the source immediately. In this case, we just ask for additional sources
       until we get a free one, and put the busy one back into the pool. */
    int tries = [sourcePool.sources count];
    while ((result != nil) && (result.buffersQueued > 0) && tries--) {
        NSLog(@"Dirty sound source; retrying...");
        [result clear];
        result = (ALSource*)[sourcePool getFreeSource:NO];
    }

    if (!result) {
        NSLog(@"All sources busy; Obtaining a new one (size=%d)...", [sourcePool.sources count]);
        result = [ALSource source];
        [sourcePool addSource:result];
    }

    return result;
}

-(void) updateLoop {
    if ((self.mainBuffer != nil) && (self->loopIn >= self.mainBuffer.size)) {
        NSLog(@"[ZLSound] WARN Loop-in point beyond end of sample, disabling loop");
        self->loopIn = -1;
    }
    if ((self.mainBuffer != nil) && (self->loopIn >= 0) && (self->loopOut > self->loopIn)) {
        if (self->loopOut >= self.mainBuffer.size) {
            NSLog(@"[ZLSound] WARN Loop out point beyond end of sample, setting to end of sample");        
            self->loopOut = self.mainBuffer.size - 1;
        }
        if (self->loopIn > 0) {
            self.beginBuffer = [self.mainBuffer sliceWithName:@"begin" offset:0 size:self->loopOut];
        } else {
            self.beginBuffer = nil;
        }
        self.loopBuffer = [self.mainBuffer sliceWithName:@"loop" offset:self->loopIn size:(self->loopOut - self->loopIn)];
    } else {
        self.beginBuffer = nil;
        self.loopBuffer = nil;
    }
}

#pragma mark PUBLIC

-(id)media {
    return self->media;
}

-(void)setMedia: (id)value {
    NSString *fileName = [TiUtils stringValue:value];
    bool hadMedia = (self->media != nil);

    self->media = [fileName retain];
    if ([fileName rangeOfString:@"://"].location != NSNotFound) {
        self.mainBuffer = [[OpenALManager sharedInstance] bufferFromUrl:[NSURL URLWithString:fileName]];
    } else {
        self.mainBuffer = [[OpenALManager sharedInstance] bufferFromFile:fileName];
    }

    if (self.mainBuffer == nil) {
        NSLog(@"[ZLSound] WARN Failed to load media from file %@", fileName);        
    }
    
    if (hadMedia == YES) {
        NSLog(@"[ZLSound] INFO Media changed, clearing looping points");
        self.beginBuffer = nil;
        self.loopBuffer = nil;
        self->loopIn = -1;
        self->loopOut = -1;
    }
    [self updateLoop];    
}

-(id)loopIn {
    return self->loopIn >= 0 ? NUMINT(self->loopIn) : nil;
}

-(void)setLoopIn: (id)value {
    self->loopIn = (value != nil) ? [TiUtils intValue:value] : -1;
    [self updateLoop];
}

-(id)loopOut {
    return self->loopOut >= 0 ? NUMINT(self->loopOut) : nil;
}

-(void)setLoopOut: (id)value {
    self->loopOut = (value != nil) ? [TiUtils intValue:value] : -1;
    [self updateLoop];
}

-(id)play:(id)args {
    if (_mainBuffer == nil) {
        NSLog(@"[ZLSound] No sound loaded; Please set the 'media' property before calling play().");            
        return nil;
    }
    
    @synchronized(sourcePool) {
        if (self.source == nil) {
            self.source = [self obtainSource];
            _source.pitch = self->pitch;
			_source.volume = self->volume;
			_source.pan = self->pan;
            _source.reverbSendLevel = self->reverbLevel;
            [_source queueBuffer:_mainBuffer];
            [_source play];
        } else {
            if (_source.playing) {
                NSLog(@"[ZLSound] Sound is already playing, call stop() first");
            } else {
                [_source play];
            }
        }
    }
    
    return nil;
}

-(id)loop:(id)args {
    if (_mainBuffer == nil) {
        NSLog(@"[ZLSound] No sound loaded; Please set the 'media' property before calling loop().");            
        return nil;
    }

    int times = [TiUtils intValue: [args objectAtIndex:0]];
    @synchronized(sourcePool) {
        if (self.source == nil) {
            self.source = [self obtainSource];
            _source.pitch = self->pitch;
			_source.volume = self->volume;
			_source.pan = self->pan;
            _source.reverbSendLevel = self->reverbLevel;
            if (_loopBuffer) {
                [_source queueBuffer:(_beginBuffer != nil ? _beginBuffer : _loopBuffer)];
            } else {
                [_source queueBuffer:_mainBuffer];
            }
            [_source play];
            if (times > 0) {
                [_source queueBuffer:(_loopBuffer != nil ? _loopBuffer : _mainBuffer) repeats: times];
            }
        } else {
            if (_source.playing) {
                NSLog(@"[ZLSound] INFO Sound is already playing, queueing additional loops");
                [_source queueBuffer:(_loopBuffer != nil ? _loopBuffer : _mainBuffer) repeats: times + 1];
            } else {
                [_source play];
            }
        }
    } 
    
    return nil;
}

-(id)stop:(id)args {
    @synchronized(sourcePool) {
        if (self.source != nil) {
            if (!self.source.playing) {
                //NSLog(@"[ALSound] WARN Stopped a non-playing source?! %@", self.source);
            }
            [self.source clear];
            self.source = nil;
        }
    }

    return nil;
}

-(id)playing {
    return NUMBOOL(self.source ? [self.source playing] : NO);
}

-(id)pan {
    return NUMFLOAT(self->pan);
}

-(void)setPan:(id)value {
    self->pan = [value floatValue];
	if (self.source != nil) {
		self.source.pan = self->pan;
	}
}

-(id)pitch {
    return NUMFLOAT(self->pitch);
}

-(void)setPitch:(id)value {
    self->pitch = [value floatValue];
	if (self.source != nil) {
		self.source.pitch = self->pitch;
	}
}

-(id)volume {
    return NUMFLOAT(self->volume);
}

-(void)setVolume:(id)value {
    self->volume = [value floatValue];
	if (self.source != nil) {
		self.source.volume = self->volume;
	}
}

-(id)reverbLevel {
    return NUMFLOAT(self->reverbLevel);
}

-(void)setReverbLevel:(id)value {
    self->reverbLevel = [value floatValue];
    if (self.source != nil) {
        self.source.reverbSendLevel = self->reverbLevel;
    }
}

- (void)dealloc {
    [self stop: nil];
    
    self.source = nil;
    self.beginBuffer = nil;
    self.loopBuffer = nil;
    self.mainBuffer = nil;
    [sourcePool release];
    
    [super dealloc];
}

@end
