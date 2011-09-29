/**
 * Copyright (C) 2011, Uri Shaked.
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"

#define RESERVE_SOURCES 4

@interface ComSalsarhythmsoftwareZlsoundModule : TiModule 
{
@private
    ALDevice * device;
    ALContext * context;
    ALSoundSourcePool * sourcePool;
}

@end
