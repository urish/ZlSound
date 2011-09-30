/**
 * Copyright (C) 2011, Uri Shaked.
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComSalsarhythmsoftwareZlsoundModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "ComSalsarhythmsoftwareZlsoundSampleProxy.h"

@implementation ComSalsarhythmsoftwareZlsoundModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"bbbb1a7c-4c67-4385-b0ad-be33df15e044";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.salsarhythmsoftware.zlsound";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
    device = [[ALDevice deviceWithDeviceSpecifier:nil] retain];
    context = [[ALContext contextOnDevice:device attributes:nil] retain];
    sourcePool = [[ALSoundSourcePool pool] retain];
    [OpenALManager sharedInstance].currentContext = context;
    
    for (int i = 0; i < RESERVE_SOURCES; i++) {
        [sourcePool addSource:[ALSource sourceOnContext:context]];
    }

	NSLog(@"[INFO] %@ (Zero Latency Sound Module) loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)loadSample:(id)args
{
    NSString *fileName = [TiUtils stringValue:[args objectAtIndex:0]];
    int loopIn = [TiUtils intValue:[args objectAtIndex:1]];
    int loopOut = [TiUtils intValue:[args objectAtIndex:2]];
    
    ALBuffer * buffer = nil;
    if ([fileName rangeOfString:@"://"].location != NSNotFound) {
        buffer = [[OpenALManager sharedInstance] bufferFromUrl:[NSURL URLWithString:fileName]];
    } else {
        buffer = [[OpenALManager sharedInstance] bufferFromFile:fileName];
    }
    
    return [[[ComSalsarhythmsoftwareZlsoundSampleProxy alloc] init: sourcePool: buffer: loopIn: loopOut] autorelease];
}

@end
