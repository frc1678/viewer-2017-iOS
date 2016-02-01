//
//  AppDelegate.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "AppDelegate.h"
@import DATAStack;


@interface AppDelegate ()

@property (nonatomic) bool hasCached;
@property (nonatomic) DATAStack *dataStack;

@end

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.dataStack = [[DATAStack alloc] initWithModelName:@"Model"];
    return true;
}

- (void)databaseUpdated:(NSNotification *)note {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.dataStack persistWithCompletion:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.dataStack persistWithCompletion:nil];
}


@end
