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
    [Instabug startWithToken: @"c82bc184e97be08093c702a3a1ccf80e" invocationEvent: IBGInvocationEventShake];
     [application setApplicationIconBadgeNumber:0];
//    Instabug startWithToken: "98616ae556601b6b72101615cd3f7f9a", invocationEvent:
//    NSMutableDictionary *itemDefaults = [[NSMutableDictionary alloc] init];
//    itemDefaults[@"predownloadPreference"] = NO;
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults registerDefaults: itemDefaults];
//    [userDefaults synchronize];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}



@end
