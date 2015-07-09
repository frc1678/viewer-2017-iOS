 //
//  ScoutDataFetcher.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "ScoutDataFetcher.h"
#import <CCDropboxRealmSync-iOS/CCDropboxLinkingAppDelegate.h>
#import "CCRealmSync.h"
#import "config.h"
#import "RealmModels.h"
#import "MWPhoto.h"
#import "scout_viewer_2015_iOS-Swift.h"
#import "CCDropboxSync.h"

@implementation ScoutDataFetcher

static NSArray *teams = nil;
static NSArray *matches = nil;
static Match *matchToReturn = nil;
static Team *teamToReturn = nil;
static UIImage *pdfImage = nil;

+ (DBPath *)dropboxFilePath
{
    return [[[DBPath root] childPath:DB_DATABASE_DIRECTORY] childPath:DB_DATABASE_NAME];
}

+ (NSArray *)resultsToArray:(RLMResults *)results
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (RLMObject *realmObject in results) {
        [mutableArray addObject:realmObject];
    }
    
    NSArray *array = [[NSArray alloc] initWithArray:mutableArray];
    return array;
}

+ (NSArray *)realmArrayToArray:(RLMArray *)realmArray {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (RLMObject *realmObject in realmArray) {
        [mutableArray addObject:realmObject];
    }
    
    NSArray *array = [[NSArray alloc] initWithArray:mutableArray];
    return array;
}

+ (void) reloadAllData
{
    [CCRealmSync defaultReadonlyDropboxRealm:^(RLMRealm *realm) {
        RLMResults *teamsResult = [Team allObjectsInRealm:realm];
        RLMResults *sortedTeamsResult = [teamsResult sortedResultsUsingProperty:REALM_SEED_PROPERTY ascending:YES];
        teams = [ScoutDataFetcher resultsToArray:sortedTeamsResult];
        
        RLMResults *matchesResult = [Match allObjectsInRealm:realm];
        matches = [ScoutDataFetcher resultsToArray:matchesResult];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SCOUT_VIEWER_DATABASE_UPDATE object:nil];
    }];
}

+ (NSArray *)fetchTeamsByDescriptor:(NSSortDescriptor *)descriptor
{
    return [teams sortedArrayUsingDescriptors:@[descriptor, [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES]]];
}

+ (NSArray *)fetchAndFilterMechansimTeamsByDescriptor:(NSSortDescriptor *)descriptor
{
    NSArray *ts = [teams sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"uploadedData.easeOfMounting" ascending:NO], descriptor, [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES]]];
    
    NSMutableArray *filteredTeams = [[NSMutableArray alloc] init];
    for (Team *team in ts) {
        if (team.uploadedData.canMountMechanism == YES && team.uploadedData.willingToMount == YES && [CAN_PROGRAM_LANGUAGES containsObject:team.uploadedData.programmingLanguage]) {
            [filteredTeams addObject:team];
        }
    }
    
    return filteredTeams;
}

+ (NSArray *)fetchMatches:(BOOL)shouldForce {
     
    return matches;
}

+ (NSArray *)teamNumbersFromTeams:(NSArray *)teams {
    NSMutableArray *teamNumbers = [[NSMutableArray alloc] init];
    for (Team *team in teams) {
        [teamNumbers addObject:[NSNumber numberWithInt:(int)team.number]];
    }
    
    return [[NSArray alloc] initWithArray:teamNumbers];
}

+ (NSArray *)fetchMatchesForTeamWithNumber:(NSInteger)teamNumber {
    NSMutableArray *matchesWithTeam = [[NSMutableArray alloc] init];
    for (Match *match in matches) {
        if ([[ScoutDataFetcher teamNumbersFromTeams:[ScoutDataFetcher realmArrayToArray:match.redTeams]] containsObject:[NSNumber numberWithInt:(int)teamNumber]] || [[ScoutDataFetcher teamNumbersFromTeams:[ScoutDataFetcher realmArrayToArray:match.blueTeams]] containsObject:[NSNumber numberWithInt:(int)teamNumber]]) {
            [matchesWithTeam addObject:match];
        }
    }
    
    return matchesWithTeam;
}

+ (TeamInMatchData *)fetchTeamInMatchDataForTeam:(Team *)team inMatch:(Match *)match {
    for (TeamInMatchData *timData in team.matchData) {
        if ([timData.match.match isEqualToString:match.match]) {
            return timData;
        }
    }
    
    return nil;
}

+ (NSArray *)fetchTeamsInMatch:(Match *)match isRed:(BOOL)isRed {
    [CCRealmSync defaultReadonlyDropboxRealm:^(RLMRealm *realm) {
        if (isRed) {
            teams = [ScoutDataFetcher realmArrayToArray:match.redTeams];
        } else {
            teams = [ScoutDataFetcher realmArrayToArray:match.blueTeams];
        }
    }];
    
    return teams;
}

+ (Match *)fetchMatch:(NSString *)match {
    [CCRealmSync defaultReadonlyDropboxRealm:^(RLMRealm *realm) {
        RLMResults *matchesResult = [Match objectsInRealm:realm where:[NSString stringWithFormat:@"match = '%@'", match]];
        matchToReturn = [matchesResult firstObject];
    }];
    
    return matchToReturn;
}

+ (Team *)fetchTeam:(NSInteger)team {
    for (Team *t in teams) {
        if (t.number == team) {
            return t;
        }
    }
    
    return nil;
}

+ (NSInteger)rankOfTeam:(Team *)team withCharacteristic:(NSString *)characteristic {
    
    NSArray *sortedArray = [teams sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:characteristic ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES]]];
    
    NSMutableArray *teamNumbers = [[NSMutableArray alloc] init];
    for (Team *loopTeam in sortedArray) {
        NSNumber *number = [NSNumber numberWithInteger:loopTeam.number];
        [teamNumbers addObject:number];
    }
    
    return [teamNumbers indexOfObject:[NSNumber numberWithInteger:team.number]] + 1;
}

+ (NSArray *)ranksOfTeamsWithCharacteristic:(NSString *)characteristic {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (Team *team in teams) {
        [values addObject:[NSNumber numberWithInteger:[ScoutDataFetcher rankOfTeam:team withCharacteristic:characteristic]]];
    }
    
    return values;
}

+ (NSInteger)rankOfTeamInMatchData:(TeamInMatchData *)timData withCharacteristic:(NSString *)characteristic {
    
    NSArray *sortedArray = [[ScoutDataFetcher realmArrayToArray:timData.team.matchData] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:characteristic ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"match.match" ascending:YES]]];
    
    NSMutableArray *teamNumbers = [[NSMutableArray alloc] init];
    for (TeamInMatchData *loopTIMData in sortedArray) {
        NSString *match = loopTIMData.match.match;
        [teamNumbers addObject:match];
    }
    
    return [teamNumbers indexOfObject:timData.match.match] + 1;
}


+ (NSArray *)ranksOfTeamInMatchDatasWithCharacteristic:(NSString *)characteristic forTeam:(Team *)team{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (TeamInMatchData *timData in team.matchData) {
        [values addObject:[NSNumber numberWithInteger:[ScoutDataFetcher rankOfTeamInMatchData:timData withCharacteristic:characteristic]]];
    }
    
    return values;
}

+ (UIImage *)getSelectedImageForTeam:(NSInteger)team ofSize:(DBThumbSize)size {
    
    NSData *data = [[NSData alloc] init];
        
    DBPath *selectedPath = [[DBPath root] childPath:[NSString stringWithFormat:@"Robot Photos/%ld/selectedImage.jpg", (long)team]];
    DBFileInfo *info = [[DBFilesystem sharedFilesystem] fileInfoForPath:selectedPath error:nil];
    if (info) {
        DBFile *file = [[DBFilesystem sharedFilesystem] openThumbnail:selectedPath ofSize:size inFormat:DBThumbFormatPNG error:nil];
        data = [file readData:nil];
        [file close];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}

+ (UIImage *)getImageForTeam:(NSInteger)team withName:(NSString *)name ofSize:(DBThumbSize)size {
    NSData *data = [[NSData alloc] init];
    
    DBPath *path = [[DBPath root] childPath:[NSString stringWithFormat:@"Robot Photos/%ld/%@.jpg", (long)team, name]];
    DBFileInfo *info = [[DBFilesystem sharedFilesystem] fileInfoForPath:path error:nil];
    if (info) {
        DBFile *file = [[DBFilesystem sharedFilesystem] openThumbnail:path ofSize:size inFormat:DBThumbFormatPNG error:nil];
        data = [file readData:nil];
        [file close];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}

+ (void)getTeamImage:(NSInteger)team ofSize:(DBThumbSize)size {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = [ScoutDataFetcher getSelectedImageForTeam:team ofSize:size];
    
        if (!image) {
            image = [ScoutDataFetcher getImageForTeam:team withName:@"0" ofSize:size];
        }
    
        NSLog(@"Loaded image for team %ld", team);
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"gotTeamImage" object:image userInfo:nil]];
    });
}

+ (UIImage *)getSelectedPDFImageForTeam:(NSInteger)team withSize:(DBThumbSize)size {
 
    NSData *data = [[NSData alloc] init];
 
    DBPath *selectedPath = [[DBPath root] childPath:[NSString stringWithFormat:@"Robot Photos/%ld/selectedImage.jpg", (long)team]];
    DBFileInfo *info = [[DBFilesystem sharedFilesystem] fileInfoForPath:selectedPath error:nil];
    if (info) {
        DBFile *file = [[DBFilesystem sharedFilesystem] openThumbnail:selectedPath ofSize:size inFormat:DBThumbFormatPNG error:nil];
        data = [file readData:nil];
        [file close];
    }

    UIImage *image = [UIImage imageWithData:data];

    return image;
 }
 
+ (UIImage *)getPDFImageForTeam:(NSInteger)team withName:(NSString *)name withSize:(DBThumbSize)size {
    NSData *data = [[NSData alloc] init];

    DBPath *path = [[DBPath root] childPath:[NSString stringWithFormat:@"Robot Photos/%ld/%@.jpg", (long)team, name]];
    DBFileInfo *info = [[DBFilesystem sharedFilesystem] fileInfoForPath:path error:nil];
    if (info) {
        DBFile *file = [[DBFilesystem sharedFilesystem] openThumbnail:path ofSize:DBThumbSizeXL inFormat:DBThumbFormatPNG error:nil];
        data = [file readData:nil];
        [file close];
    }

    UIImage *image = [UIImage imageWithData:data];

    return image;
}

+ (UIImage *)getTeamPDFImage:(NSInteger)team withSize:(DBThumbSize)size {
    pdfImage = nil;
        pdfImage = [ScoutDataFetcher getSelectedPDFImageForTeam:team withSize:size];

        if (!pdfImage) {
            pdfImage = [ScoutDataFetcher getPDFImageForTeam:team withName:@"0" withSize:size];
        }
    
    return pdfImage;
}

+ (void)getTeamImagesForTeam:(NSInteger)team {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        
        DBPath *path = [[DBPath root] childPath:[NSString stringWithFormat:@"Robot Photos/%ld/", (long)team]];
        
        for (DBFileInfo *info in [[DBFilesystem sharedFilesystem] listFolder:path error:nil]) {
            if (info) {
                DBFile *file = [[DBFilesystem sharedFilesystem] openFile:info.path error:nil];
                NSData *data = [file readData:nil];
                [file close];
                
                [photos addObject:[MWPhoto photoWithImage:[UIImage imageWithData:data]]];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"gotTeamImages" object:[NSArray arrayWithArray:photos] userInfo:nil]];
    });
}

+ (void)getTeamImagesForTeam:(NSInteger)team withProgresscallback:(void(^)(float progress, BOOL done, NSInteger teamNum))progressCallback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        DBPath *path = [[DBPath root] childPath:[NSString stringWithFormat:@"Robot Photos/%ld/", (long)team]];
        NSArray *photoInfos = [[DBFilesystem sharedFilesystem] listFolder:path error:nil];
        
        BOOL noErrors = YES;
        for (int i = 0; i < photoInfos.count; i++) {
            DBFileInfo *info = photoInfos[i];
            if (info) {
                NSError *error = nil;
                DBFile *file = [[DBFilesystem sharedFilesystem] openThumbnail:info.path ofSize:DBThumbSizeXL inFormat:DBThumbFormatPNG error:&error];
                NSData *data = [file readData:&error];
                
                if(!error) {
                    [file close];
                    
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"gotTeamImageToAdd" object:@[[MWPhoto photoWithImage:[UIImage imageWithData:data]], @(team)] userInfo:nil]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressCallback) {
                            progressCallback((float)(i + 1) / photoInfos.count, NO, team);
                        }
                    });
                } else {
                    noErrors = NO;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressCallback) {
                progressCallback(1, noErrors, team);
            }
        });
    });
}



+ (NSDictionary *)getGraphDataForTeam:(Team *)team forObjects:(NSArray *)objs forCharacteristicPaths:(NSArray *)characteristics withNames: (NSArray *)names withTitle:(NSString *)title {
    NSMutableDictionary *mdata = [[NSMutableDictionary alloc] init];
    
    [mdata setValue:title forKey:@"Title"];
    
    NSMutableArray *bars = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < objs.count; i++) {
        NSMutableDictionary *bar = [[NSMutableDictionary alloc] init];
        
        [bar setValue:characteristics[i] forKey:@"keyPath"];
        [bar setValue:[UIColor redColor] forKey:@"color"];
        [bar setValue:names[i] forKey:@"subTitle"];
        
        [bars addObject:bar];
    }
    
    [mdata setValue:bars forKey:@"bars"];
    
    return mdata;
}

+ (NSArray *)valuesInCompetitionOfPathForTeams:(NSString *)path {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (Team *team in teams) {
        [values addObject:[team valueForKeyPath:path]];
    }
    
    return values;
}

+ (NSArray *)valuesInCompetitionOfPathForMatches:(NSString *)path {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (Match *match in matches) {
        [values addObject:[match valueForKeyPath:path]];
    }
    
    return values;
}

+ (NSArray *)valuesInTeamMatchesOfPath:(NSString *)path forTeam:(Team *)team {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (TeamInMatchData *timData in team.matchData) {
        [values addObject:[timData valueForKeyPath:path]];
    }
    
    return values;
}

+ (NSArray *)fetchTeams {
    return teams;
}

+ (void)fetchOnMainThreadTeam:(Team *)team key:(NSString *)key object:(id)object withProperty:(NSString *)property  finished:(void (^)(id, id, NSString *))block {
    dispatch_async(dispatch_get_main_queue(), ^{
        id property = (id)[team valueForKeyPath:key];
        
        block(property, object, property);
    });
}

+ (UIImage *)cacheTeamImage:(NSInteger)team ofSize:(DBThumbSize)size {
    UIImage *image = [ScoutDataFetcher getSelectedImageForTeam:team ofSize:size];
    
    if (!image) {
        image = [ScoutDataFetcher getImageForTeam:team withName:@"0" ofSize:size];
    }
    
    NSLog(@"Loaded image for team %ld", team);
    return image;
}

+ (void)downloadAll {
    for (Team *team in teams) {
        [ScoutDataFetcher cacheTeamImage:team.number ofSize:DBThumbSizeL];
    }
}

+ (void)downloadAllwithProgressCallback:(void(^)(float progress, BOOL done))progressCallback {
    __block NSMutableArray *nums = [[NSMutableArray alloc] init];
    for (Team *team in teams) {
        [nums addObject:@(team.number)];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (int i = 0; i < nums.count; i++) {
            [ScoutDataFetcher cacheTeamImage:[nums[i] integerValue] ofSize:DBThumbSizeL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressCallback) {
                    progressCallback((float)(i + 1) / teams.count, NO);
                }
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressCallback) {
                progressCallback(1, YES);
            }
        });
    });
}

+ (NSArray *)allTeamsInMatch:(Match *)match {
    NSMutableArray *teams = [[NSMutableArray alloc] initWithArray:[ScoutDataFetcher realmArrayToArray:match.redTeams]];
    [teams addObjectsFromArray:[ScoutDataFetcher realmArrayToArray:match.blueTeams]];
    
    return teams;
}



@end
