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

-(id)init: (ALSoundSourcePool*)pool: (ALBuffer*)buffer: (int)loopIn: (int)loopOut {
    if ((self = [super init])) {
        sourcePool = [pool retain];
        mainBuffer = [buffer retain];
        beginBuffer = [[mainBuffer sliceWithName:@"begin" offset:0 size:loopOut] retain];
        loopBuffer = [[mainBuffer sliceWithName:@"loop" offset:loopIn size:(loopOut-loopIn)] retain];
        loopBuffer.freeDataOnDestroy = NO;
        source = nil;
        self->pitch = 1.0f;
		self->volume = 1.0f;
		self->pan = 0.0f;
    }
    
    return self;
}

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

-(id)play:(id)args {
    @synchronized(sourcePool) {
        if (source == nil) {
            source = [[self obtainSource] retain];
            source.pitch = self->pitch;
			source.volume = self->volume;
			source.pan = self->pan;
            [source queueBuffer:beginBuffer];
            [source play];
            [source queueBuffer: loopBuffer repeat: LOOP_REPEAT_TIMES];
        }
    }
    
    return nil;
}

-(id)stop:(id)args {
    @synchronized(sourcePool) {
        if (source != nil) {
            if (!source.playing) {
                NSLog(@"STOP but not playing? Will leak! %@", source);
            }
            [source clear];
            [source release];
            source = nil;
        }
    }

    return nil;
}

-(id)playing {
    return NUMBOOL(source ? [source playing] : NO);
}

-(id)pan {
    return NUMFLOAT(self->pan);
}

-(void)setPitch:(id)value {
    self->pitch = [value floatValue];
	if (source != nil) {
		source.pan = self->pan;
	}
}

-(id)pitch {
    return NUMFLOAT(self->pitch);
}

-(void)setPitch:(id)value {
    self->pitch = [value floatValue];
	if (source != nil) {
		source.pitch = self->pitch;
	}
}

-(id)volume {
    return NUMFLOAT(self->volume);
}

-(void)setVolume:(id)value {
    self->volume = [value floatValue];
	if (source != nil) {
		source.volume = self->volume;
	}
}

- (void)dealloc {
    [self stop: nil];
    
    [source release];
    [beginBuffer release];
    [loopBuffer release];
    [mainBuffer release];
    [sourcePool release];
    
    [super dealloc];
}

@end
