//
//  FirstPickTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "FirstPickTableViewController.h"
#import "MultiCellTableViewCell.h"
#import "config.h"
#import "scout_viewer_2015_iOS-Swift.h"

@interface FirstPickTableViewController ()

@end

@implementation FirstPickTableViewController


-(void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkRes:) name:@"updateLeftTable" object:nil];
    

}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%lu",(unsigned long)firebaseFetcher.teams.count);
//    return firebaseFetcher.getPickList.count;
//}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"MultiCellTableViewCell" owner:self options:nil];
//    MultiCellTableViewCell *cell = [nib objectAtIndex:0];
//    Team *team = firebaseFetcher.getPickList[indexPath.row];
//    cell.teamLabel.text = [NSString stringWithFormat:@"%d",team.number];
//    cell.rankLabel.text = [NSString stringWithFormat:@"%d",(indexPath.row+1)];
//    cell.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)team.calculatedData.firstPickAbility];
//    
//    return cell;
//}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    
    
    MultiCellTableViewCell *multiCell = (MultiCellTableViewCell *)cell;
    
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.firebaseFetcher rankOfTeam:team withCharacteristic:@"calculatedData.firstPickAbility"]];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number.integerValue];
    if(team.calculatedData.firstPickAbility != nil) {
        multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                     [Utils roundValue:team.calculatedData.firstPickAbility.floatValue toDecimalPlaces:2]];
    } else {
        multiCell.scoreLabel.text = @"";
    }
    
    
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    //NSArray *returnData = [firebaseFetcher fetchTeamsByDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"calculatedData.firstPickAbility" ascending:NO]];
    NSArray *returnData = [self.firebaseFetcher getPickList];
    return returnData;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.destinationViewController isKindOfClass:[TeamDetailsTableViewController class]]) {
        MultiCellTableViewCell *multiCell = sender;
        
        TeamDetailsTableViewController *teamDetailsController = segue.destinationViewController;
        Team *team = [self.firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]];
        NSLog(@"This is the passed team Number:");
        teamDetailsController.data = team;
    } else if ([segue.destinationViewController isKindOfClass:[NthPickMechanismFilteredTableViewController class]]) {
        NthPickMechanismFilteredTableViewController *secondPickController = segue.destinationViewController;
        
        secondPickController.order = 1;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"TeamDetails" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.firebaseFetcher filteredTeamsForSearchString:searchString];
//    return [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Team *team, NSDictionary *bindings) {
//        NSString *numberText = [NSString stringWithFormat:@"%ld", (long)team.number];
//        return [numberText rangeOfString:searchString].location == 0;
//    }]];
}
//-(void)checkRes:(NSNotification *)notification
//{
//    if ([[notification name] isEqualToString:@"updateLeftTable"])
//    {
//        [self refreshData];
//    }
//}

-(NSString *)notificationName {
    return @"updatedLeftTable";
}



@end
