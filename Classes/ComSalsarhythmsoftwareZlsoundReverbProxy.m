//
//  ComSalsarhythmsoftwareZlsoundReverbProxy.m
//  zlsound
//
//  Created by Uri Shaked on 3/9/12.
//  Copyright (c) 2012 Uri Shaked. All rights reserved.
//

#import "ComSalsarhythmsoftwareZlsoundReverbProxy.h"
#import "TiUtils.h"

@implementation ComSalsarhythmsoftwareZlsoundReverbProxy

-(id)initWithListener: (ALListener*)_listener {
    if ((self = [super init])) {
        self->listener = [_listener retain];
    }
    return self;
}

-(void)dealloc {
	[listener release];
	[super dealloc];
}

#define TI_CONST(name, value) -(id)name { return NUMINT(value); }

TI_CONST(REVERB_SMALL_ROOM, ALC_ASA_REVERB_ROOM_TYPE_SmallRoom);
TI_CONST(REVERB_MEDIUM_ROOM, ALC_ASA_REVERB_ROOM_TYPE_MediumRoom);
TI_CONST(REVERB_LARGE_ROOM, ALC_ASA_REVERB_ROOM_TYPE_LargeRoom);
TI_CONST(REVERB_LARGE_ROOM2, ALC_ASA_REVERB_ROOM_TYPE_LargeRoom2);
TI_CONST(REVERB_MEDIUM_HALL, ALC_ASA_REVERB_ROOM_TYPE_MediumHall);
TI_CONST(REVERB_MEDIUM_HALL2, ALC_ASA_REVERB_ROOM_TYPE_MediumHall2);
TI_CONST(REVERB_MEDIUM_HALL3, ALC_ASA_REVERB_ROOM_TYPE_MediumHall3);
TI_CONST(REVERB_LARGE_HALL, ALC_ASA_REVERB_ROOM_TYPE_LargeHall);
TI_CONST(REVERB_LARGE_HALL2, ALC_ASA_REVERB_ROOM_TYPE_LargeHall2);
TI_CONST(REVERB_MEDIUM_CHAMBER, ALC_ASA_REVERB_ROOM_TYPE_MediumChamber);
TI_CONST(REVERB_LARGE_CHAMBER, ALC_ASA_REVERB_ROOM_TYPE_LargeChamber);
TI_CONST(REVERB_PLATE, ALC_ASA_REVERB_ROOM_TYPE_Plate);
TI_CONST(REVERB_CATHEDRAL, ALC_ASA_REVERB_ROOM_TYPE_Cathedral);

-(id)enabled {
    return NUMBOOL(listener.reverbOn);
}

-(void)setEnabled:(id)value {
    listener.reverbOn = [TiUtils boolValue:value];
}

-(id)roomType {
    return NUMINT(listener.reverbRoomType);
}

-(void)setRoomType: (id)value {
    listener.reverbRoomType = [TiUtils intValue:value];  
}

@end
