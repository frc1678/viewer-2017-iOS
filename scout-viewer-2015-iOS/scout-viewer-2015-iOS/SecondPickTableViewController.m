//
//  SecondPickTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "SecondPickTableViewController.h"
#import "MultiCellTableViewCell.h"
#import "config.h"
#import "scout_viewer_2015_iOS-Swift.h"


@interface SecondPickTableViewController ()

@end

@implementation SecondPickTableViewController

FirebaseDataFetcher *firebaseFetcher;

-(void)viewDidLoad {
    firebaseFetcher = [[FirebaseDataFetcher alloc] init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return firebaseFetcher.teams.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"MultiCellTableViewCell" owner:self options:nil];
    MultiCellTableViewCell *multiCell = [nib objectAtIndex:0];
    
    Team *team = [firebaseFetcher getPickList][indexPath.row];
    
    multiCell.teamLabel.text = team.name;
    multiCell.scoreLabel.text = [NSString stringWithFormat:@"%d",team.calculatedData.secondPickAbility];
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
                           
    return multiCell;
    

}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    
    NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"MultiCellTableViewCell" owner:self options:nil];
    MultiCellTableViewCell *multiCell = [nib objectAtIndex:0];
    
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)[firebaseFetcher rankOfTeam:team withCharacteristic:@"calculatedData.secondPickAbility"]];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number];
    multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                 [Utils roundValue:team.calculatedData.secondPickAbility toDecimalPlaces:2]];
    
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [firebaseFetcher fetchTeamsByDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"calculatedData.secondPickAbility" ascending:NO]];
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
        
        if ([firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]].calculatedData.actualSeed > 0) {
            teamDetailsController.data = [firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]];
        }
    }
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Team *team, NSDictionary *bindings) {
        NSString *numberText = [NSString stringWithFormat:@"%ld", team.number];
        return [numberText rangeOfString:searchString].location == 0;
    }]];
}

@end
