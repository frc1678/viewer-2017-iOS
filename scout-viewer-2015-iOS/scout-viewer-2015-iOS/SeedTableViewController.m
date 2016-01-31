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

FirebaseDataFetcher *firebaseFetcher;

-(void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkRes:) name:@"updateLeftTable" object:nil];
    firebaseFetcher = [[FirebaseDataFetcher alloc] init];
     
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"MultiCellTableViewCell" owner:self options:nil];
    MultiCellTableViewCell *cell = [nib objectAtIndex:0];
    
    NSArray *sortedTeams = [firebaseFetcher seedList];
    Team *team = sortedTeams[indexPath.row];
    cell.teamLabel.text = team.name;
    cell.rankLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%d",team.calculatedData.firstPickAbility];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"How many rows?");
    NSLog([NSString stringWithFormat:@"%lu",(unsigned long)firebaseFetcher.teams.count]);
    return firebaseFetcher.getPickList.count;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    
    MultiCellTableViewCell *multiCell = (MultiCellTableViewCell *)cell;
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)team.calculatedData.actualSeed];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number];
    multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                 [Utils roundValue:team.calculatedData.firstPickAbility toDecimalPlaces:2]];
    
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [firebaseFetcher fetchTeamsByDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"seed" ascending:YES]];
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
    
        
        Team *team = [firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]];
        if (team.calculatedData.actualSeed > 0) {
            teamDetailsController.data = [firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]];
        }
    }
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Team *team, NSDictionary *bindings) {
        NSString *numberText = [NSString stringWithFormat:@"%ld", (long)team.number];
        return [numberText rangeOfString:searchString].location == 0;
    }]];
}
-(void)checkRes:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"updateLeftTable"])
    {
        NSLog(@"Updating via checkRes!");
        [self.tableView reloadData];
    }
}


@end
