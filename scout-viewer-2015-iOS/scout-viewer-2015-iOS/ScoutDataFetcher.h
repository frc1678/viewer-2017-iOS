//
//  ScoutDataFetcher.h
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCRealmSync.h"
#import "RealmModels.h"

#define SCOUT_VIEWER_DATABASE_UPDATE @"SCOUT_VIEWER_DATABASE_UPDATE"
#define SCOUT_VIEWER_CACHE_PROGRESS_CHANGE @"SCOUT_VIEWER_CACHE_PROGRESS_CHANGE"
#define SCOUT_VIEWER_CACHE_STATUS_CHANGE @"SCOUT_VIEWER_CACHE_STATUS_CHANGE"

@interface ScoutDataFetcher : NSObject

+ (DBPath *)dropboxFilePath;
+ (NSArray *)realmArrayToArray:(RLMArray *)realmArray;

+ (void) reloadAllData;
+ (NSArray *)fetchTeamsByDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)fetchAndFilterMechansimTeamsByDescriptor:(NSSortDescriptor *)descriptor;
+ (NSArray *)fetchMatches:(BOOL)shouldForce;
+ (Match *)fetchMatch:(NSString *)match;
+ (Team *)fetchTeam:(NSInteger)team;
+ (NSInteger)rankOfTeam:(Team *)team withCharacteristic:(NSString *)characteristic;
+ (void)getTeamImage:(NSInteger)team ofSize:(DBThumbSize)size;
+ (void)getTeamImagesForTeam:(NSInteger)team;
+ (NSArray *)fetchMatchesForTeamWithNumber:(NSInteger)teamNumber;
+ (NSArray *)valuesInCompetitionOfPathForTeams:(NSString *)path;
+ (NSArray *)valuesInCompetitionOfPathForMatches:(NSString *)path;
+ (NSArray *)valuesInTeamMatchesOfPath:(NSString *)path forTeam:(Team *)team;
+ (NSArray *)ranksOfTeamsWithCharacteristic:(NSString *)characteristic;
+ (NSArray *)ranksOfTeamInMatchDatasWithCharacteristic:(NSString *)characteristic forTeam:(Team *)team;
+ (NSArray *)fetchTeams;
+ (TeamInMatchData *)fetchTeamInMatchDataForTeam:(Team *)team inMatch:(Match *)match;
+ (UIImage *)getTeamPDFImage:(NSInteger)team withSize:(DBThumbSize)size;
+ (void)fetchOnMainThreadTeam:(Team *)team key:(NSString *)key object:(id)object withProperty:(NSString *)property  finished:(void (^)(id, id, NSString *))block;
+ (void)downloadAll;
+ (NSArray *)allTeamsInMatch:(Match *)match;
+ (void)downloadAllwithProgressCallback:(void(^)(float progress, BOOL done))progressCallback;
+ (void)getTeamImagesForTeam:(NSInteger)team withProgresscallback:(void(^)(float progress, BOOL done, NSInteger teamNum))progressCallback;
@end
