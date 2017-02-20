//
//  AppDelegate.h
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@class FirebaseDataFetcher;
@interface AppDelegate: NSObject <UIApplicationDelegate>

@property(strong,nonatomic) UIWindow *window;
@property(strong,nonatomic) FirebaseDataFetcher *firebaseFetcher;

+ (AppDelegate *)getAppDelegate;



@end

