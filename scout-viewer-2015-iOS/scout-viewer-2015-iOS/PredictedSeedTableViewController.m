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
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)(path.row + 1)];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number.integerValue];
    multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                 [Utils roundValue:team.calculatedData.predictedSeed.floatValue toDecimalPlaces:2]];
    
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [self.firebaseFetcher predSeedList];
    NSLog(@"%lu", (unsigned long)returnData.count);
    return returnData;
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
        teamDetailsController.data = [self.firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]];
    }
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Team *team, NSDictionary *bindings) {
        NSString *numberText = [NSString stringWithFormat:@"%@", team.number];
        return [numberText rangeOfString:searchString].location == 0;
    }]];
}

@end
