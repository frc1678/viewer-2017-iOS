//
//  AppDelegate.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "AppDelegate.h"
#import "Firebase.h"


@interface AppDelegate ()

@property (nonatomic) bool hasCached;

@end

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Firebase.defaultConfig().persistenceEnabled = true //You need this so it stores to disk and doesnt go away when app is killed
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
