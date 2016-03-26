//
//  AppDelegate.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "AppDelegate.h"
#import "scout_viewer_2015_iOS-Swift.h"
#import "Firebase/Firebase.h"
#import <Instabug/Instabug.h>


@interface AppDelegate ()

@property (nonatomic) bool hasCached;

@end

@implementation AppDelegate

+ (AppDelegate *)getAppDelegate
{
    return [[UIApplication sharedApplication] delegate];
}


- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Firebase defaultConfig].persistenceEnabled = YES;
    self.firebaseFetcher = [[FirebaseDataFetcher alloc] init];
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    [Instabug startWithToken: @"98616ae556601b6b72101615cd3f7f9a" invocationEvent: IBGInvocationEventShake];
//    Instabug startWithToken: "98616ae556601b6b72101615cd3f7f9a", invocationEvent:

    return YES;
}



- (void)databaseUpdated:(NSNotification *)note {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}



@end
