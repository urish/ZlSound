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
    ALBuffer * _mainBuffer;
    ALBuffer * _beginBuffer;
    ALBuffer * _loopBuffer;
    ALSource * _source;
    
    NSString * media;

    float pitch;
	float volume;
	float pan;
    float reverbLevel;
    
    int loopIn;
    int loopOut;
}

@property (nonatomic, retain) ALBuffer * mainBuffer;
@property (nonatomic, retain) ALBuffer * beginBuffer;
@property (nonatomic, retain) ALBuffer * loopBuffer;
@property (nonatomic, retain) ALSource * source;

-(id)initWithSourcePool: (ALSoundSourcePool*)pool andArgs:(id)args;

@end
