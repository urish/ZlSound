//
//  ComSalsarhythmsoftwareZlsoundSampleProxy.h
//  alsound
//
//  Created by uri on 7/9/11.
//  Copyright 2011 Uri Shaked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TiProxy.h"
#import "ObjectAL.h"

@interface ComSalsarhythmsoftwareZlsoundSampleProxy : TiProxy {
    ALSoundSourcePool * sourcePool;
    ALBuffer * mainBuffer;
    ALBuffer * beginBuffer;
    ALBuffer * loopBuffer;
    ALSource * source;

    float pitch;
	float volume;
	float pan;
}

-(id)init: (ALSoundSourcePool*)pool :(ALBuffer*)buffer: (int)loopIn: (int)loopOut;

@end
