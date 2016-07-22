//
//  PredictedSeedTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/16/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "PredictedSeedTableViewController.h"
#import "config.h"
#import "MultiCellTableViewCell.h"
#import "scout_viewer_2015_iOS-Swift.h"


@interface PredictedSeedTableViewController ()

@end

@implementation PredictedSeedTableViewController


-(void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    
    MultiCellTableViewCell *multiCell = (MultiCellTableViewCell *)cell;
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)([self.firebaseFetcher reverseRankOfTeam:team withCharacteristic:@"calculatedData.predictedSeed"])];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number.integerValue];
    if(team.calculatedData.predictedNumRPs != nil) {
        multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                     [Utils roundValue:team.calculatedData.predictedNumRPs.floatValue toDecimalPlaces:2]];
    } else {
        multiCell.scoreLabel.text = @"";
    }
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    return [self.firebaseFetcher predSeedList];
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
