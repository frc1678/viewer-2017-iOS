//
//  ThirdPickTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 3/27/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "ThirdPickTableViewController.h"
#import "MultiCellTableViewCell.h"
#import "config.h"
#import "scout_viewer_2015_iOS-Swift.h"

@interface ThirdPickTableViewController ()
@property (strong, nonatomic) NSString *key;
@end

@implementation ThirdPickTableViewController

FirebaseDataFetcher *firebaseFetcher;

- (void)viewDidLoad {
    [super viewDidLoad];
    firebaseFetcher = [[FirebaseDataFetcher alloc] init];
    
    self.key = [self keyForIndex:0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"MultiCellTableViewCell" owner:self options:nil];
    MultiCellTableViewCell *multiCell = [nib objectAtIndex:0];
    
    multiCell.rankLabel.text = @"Hello, this won't be needed until champs :)";
    multiCell.teamLabel.text = @"";
    multiCell.scoreLabel.text = @"";
    
    return multiCell;
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
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)[firebaseFetcher rankOfTeam:team withCharacteristic:self.key]];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number];
    multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                 [Utils roundValue:[[team valueForKeyPath:self.key] floatValue] toDecimalPlaces:2]];
    
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = firebaseFetcher.teams;
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
    } else if ([segue.destinationViewController isKindOfClass:[NthPickMechanismFilteredTableViewController class]]) {
        NthPickMechanismFilteredTableViewController *secondPickController = segue.destinationViewController;
        
        secondPickController.order = 3;
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
