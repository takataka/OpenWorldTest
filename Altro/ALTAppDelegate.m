//
//  ALTAppDelegate.m
//  Altro
//
//  Created by Mike Rotondo on 6/1/13.
//  Copyright (c) 2013 Taka Taka. All rights reserved.
//

#import "ALTAppDelegate.h"
#import "SKRAppDelegate.h"

@implementation ALTAppDelegate
{
	IBOutlet NSView *_view;
    SKRAppDelegate *_skrAppDelegate;
}

-	 (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    _skrAppDelegate = [[SKRAppDelegate alloc] initWithWindow:_window skrView:(SKRView *)_view worldGenerator:nil];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
    [_skrAppDelegate applicationWillBecomeActive:notification];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [_skrAppDelegate applicationWillResignActive:notification];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [_skrAppDelegate applicationWillTerminate:notification];
}

@end