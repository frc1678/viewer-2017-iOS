//
//  TeamTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "TeamTableViewController.h"
#import "ScoutDataFetcher.h"
#import "config.h"
#import "RealmModels.h"

@interface TeamTableViewController ()

@end

@implementation TeamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [ScoutDataFetcher fetchTeamsByDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES]];
    return returnData;
}

- (NSString *)cellIdentifier {
    return TEAM_CELL_IDENTIFIER;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number];
}

@end
