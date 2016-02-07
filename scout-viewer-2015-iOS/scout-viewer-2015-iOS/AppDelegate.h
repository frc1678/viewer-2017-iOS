//
//  AppDelegate.h
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirebaseDataFetcher;
@interface AppDelegate: NSObject

@property(strong,nonatomic) UIWindow *window;
@property(strong,nonatomic) FirebaseDataFetcher *firebaseFetcher;

+ (AppDelegate *)getAppDelegate;



@end

