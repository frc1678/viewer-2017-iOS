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
@import DATAStack;


@interface AppDelegate ()

@property (nonatomic) bool hasCached;
@property (nonatomic) DATAStack *dataStack;

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
    
    return YES;
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
