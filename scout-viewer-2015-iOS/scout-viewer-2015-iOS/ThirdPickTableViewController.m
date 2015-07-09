//
//  ThirdPickTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 3/27/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "ThirdPickTableViewController.h"
#import "RealmModels.h"
#import "MultiCellTableViewCell.h"
#import "config.h"
#import "ScoutDataFetcher.h"
#import "scout_viewer_2015_iOS-Swift.h"

@interface ThirdPickTableViewController ()
@property (strong, nonatomic) NSString *key;
@end

@implementation ThirdPickTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.key = [self keyForIndex:0];
}

- (void) setKey:(NSString *)key {
    _key = key;
    
    self.dataArray = [self loadDataArray:YES];
    [self.tableView reloadData];
}

- (IBAction)thirdPickSettingChanged:(UISegmentedControl *)sender {
    self.key = [self keyForIndex:sender.selectedSegmentIndex];
}

- (NSString *)keyForIndex:(NSInteger)index {
    NSArray *settingMap = @[@"calculatedData.thirdPickAbility", @"calculatedData.thirdPickAbilityLandfill"];
    
    return settingMap[index];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    
    MultiCellTableViewCell *multiCell = (MultiCellTableViewCell *)cell;
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)[ScoutDataFetcher rankOfTeam:team withCharacteristic:self.key]];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number];
    multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                 [Utils roundValue:[[team valueForKeyPath:self.key] floatValue] toDecimalPlaces:2]];
    
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [ScoutDataFetcher fetchTeamsByDescriptor:[NSSortDescriptor sortDescriptorWithKey:self.key ascending:NO]];
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
        
        if ([ScoutDataFetcher fetchTeam:[multiCell.teamLabel.text integerValue]].seed > 0) {
            teamDetailsController.data = [ScoutDataFetcher fetchTeam:[multiCell.teamLabel.text integerValue]];
        }
    } else if ([segue.destinationViewController isKindOfClass:[NthPickMechanismFilteredTableViewController class]]) {
        NthPickMechanismFilteredTableViewController *secondPickController = segue.destinationViewController;
        
        secondPickController.order = 3;
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
