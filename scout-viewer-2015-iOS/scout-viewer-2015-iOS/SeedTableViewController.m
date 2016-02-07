//
//  SeedTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "seedTableViewController.h"

#import "config.h"
#import "MultiCellTableViewCell.h"
#import "scout_viewer_2015_iOS-Swift.h"


@interface SeedTableViewController ()

@end

@implementation SeedTableViewController


-(void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    
    MultiCellTableViewCell *multiCell = (MultiCellTableViewCell *)cell;
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)team.calculatedData.actualSeed];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number];
    multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                 [Utils roundValue:team.calculatedData.firstPickAbility toDecimalPlaces:2]];
    //Ask about this
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [self.firebaseFetcher fetchTeamsByDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"seed" ascending:YES]];
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
    
        
        Team *team = [self.firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]];
        teamDetailsController.data = [self.firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]];
    }
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Team *team, NSDictionary *bindings) {
        NSString *numberText = [NSString stringWithFormat:@"%ld", (long)team.number];
        return [numberText rangeOfString:searchString].location == 0;
    }]];
}


@end
