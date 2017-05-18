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
#import "ios_viewer-Swift.h"


@interface SeedTableViewController ()

@end

@implementation SeedTableViewController


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    MultiCellTableViewCell *multiCell = (MultiCellTableViewCell *)cell;
    
    if(team.calculatedData.actualSeed != nil){
        //get the rank where higher numbers are on the top
        multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", [self.firebaseFetcher reverseRankOfTeam:team withCharacteristic:@"calculatedData.actualSeed"]];
    } else {
        multiCell.rankLabel.text = @"NA";
    }
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number];
    
    if(team.calculatedData.actualNumRPs != -1.0) {
        //score label is average number of rps
        multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@", [Utils roundValue:team.calculatedData.actualNumRPs toDecimalPlaces:2]]; // Actually is average Num RPs
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
