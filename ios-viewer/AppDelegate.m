//
//  AppDelegate.m
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

#import "AppDelegate.h"
#import "ios_viewer-Swift.h"
@import Firebase;
#import <Instabug/Instabug.h>
#import <UserNotifications/UserNotifications.h>
@import HockeySDK;

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
    [FIRApp configure];
    [FIRDatabase database].persistenceEnabled = YES;
    self.firebaseFetcher = [[FirebaseDataFetcher alloc] init];
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge + UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        //
    }];
    [Instabug startWithToken: @"c82bc184e97be08093c702a3a1ccf80e" invocationEvent: IBGInvocationEventShake];
    [application setApplicationIconBadgeNumber:0];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"89774ebc4b4d4c95a24d92da8003f355"]; // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation]; // This line is obsolete in the crash only builds
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}



@end
