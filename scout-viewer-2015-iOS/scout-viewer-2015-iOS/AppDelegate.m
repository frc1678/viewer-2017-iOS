//
//  AppDelegate.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "AppDelegate.h"
#import <CCDropboxRealmSync-iOS/CCRealmSync.h>
#import "ScoutDataFetcher.h"

@interface AppDelegate ()

@property (nonatomic) bool hasCached;

@end

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL ret = [super application:application didFinishLaunchingWithOptions:launchOptions];
    self.hasCached = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(databaseUpdated:) name:CC_NEW_REALM_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUIBecauseDropboxIsLinkedNow) name:CC_DROPBOX_LINK_NOTIFICATION object:nil];
    [CCRealmSync setRealmDropboxPath:[ScoutDataFetcher dropboxFilePath]];
    
    [CCRealmSync defaultReadonlyDropboxRealm:^(RLMRealm *realm) {
        NSLog(@"Initial setup of realm %@", realm);
        [ScoutDataFetcher reloadAllData];
    }];
    
    return ret;
}

- (void)databaseUpdated:(NSNotification *)note {
    [ScoutDataFetcher reloadAllData];
}

- (void)reloadUIBecauseDropboxIsLinkedNow {
    [ScoutDataFetcher reloadAllData];
}

@end
