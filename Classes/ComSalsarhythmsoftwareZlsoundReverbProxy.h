//
//  ComSalsarhythmsoftwareZlsoundReverbProxy.h
//  zlsound
//
//  Created by Uri Shaked on 3/9/12.
//  Copyright (c) 2012 Uri Shaked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TiProxy.h"
#import "ObjectAL.h"

@interface ComSalsarhythmsoftwareZlsoundReverbProxy : TiProxy
{
    ALListener *listener;    
}

-(id)initWithListener: (ALListener*)listener;

@end
