//
//  TeamTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "TeamTableViewController.h"
#import "config.h"
#import "scout_viewer_2015_iOS-Swift.h"


@interface TeamTableViewController ()

@end

@implementation TeamTableViewController

FirebaseDataFetcher *firebaseFetcher;

- (void)viewDidLoad {
    firebaseFetcher = [[FirebaseDataFetcher alloc] init];
    [super viewDidLoad];
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [firebaseFetcher.teams sortedArrayUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES]]];
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
