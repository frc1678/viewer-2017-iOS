//
//  SeedTableViewController.m
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

#import "SeedTableViewController.h"

#import "config.h"
#import "MultiCellTableViewCell.h"
#import "scout_viewer_2016_iOS-Swift.h"


@interface SeedTableViewController ()

@end

@implementation SeedTableViewController


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    MultiCellTableViewCell *multiCell = (MultiCellTableViewCell *)cell;
    
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", [self.firebaseFetcher reverseRankOfTeam:team withCharacteristic:@"calculatedData.actualSeed"]];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number.integerValue];
    
    if(team.calculatedData.actualNumRPs != nil) {
        multiCell.scoreLabel.text = [NSString stringWithFormat:@"%ld",
                                     team.calculatedData.actualNumRPs.integerValue];
    } else {
        multiCell.scoreLabel.text = @"";
    }
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    return [self.firebaseFetcher seedList];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"TeamDetails" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TeamDetailsTableViewController class]]) {
        MultiCellTableViewCell *multiCell = sender;
        TeamDetailsTableViewController *teamDetailsController = segue.destinationViewController;
        teamDetailsController.team = [self.firebaseFetcher getTeam:[multiCell.teamLabel.text integerValue]];
    }
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.firebaseFetcher filteredTeamsForSearchString:searchString];
}

@end
