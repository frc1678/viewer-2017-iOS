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
#import "NSData+NSData_HexString.h"

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
    [Instabug startWithToken: @"98616ae556601b6b72101615cd3f7f9a" invocationEvent: IBGInvocationEventShake];
    [application setApplicationIconBadgeNumber:0];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"89774ebc4b4d4c95a24d92da8003f355"]; // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation]; // This line is obsolete in the crash only builds
    [application registerForRemoteNotifications];

    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register with id of");
    //NSString *deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    NSString *deviceTokenString = [deviceToken hexString];
    NSLog(@"%@", deviceTokenString);
    [[[[[[FIRDatabase database] reference] child:@"AppTokens"] child:deviceTokenString] child:@"Token"] setValue: deviceTokenString];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:deviceTokenString forKey:@"NotificationToken"];
    [defaults synchronize];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register");
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Did recieve notification %@",userInfo[@"aps"]);
}



@end
