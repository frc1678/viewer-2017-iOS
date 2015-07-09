//
//  ArrayTableViewController.h
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArrayTableViewController : UITableViewController
    <UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *filteredArray;

//Subclasses need to override these methods:
- (NSArray *)loadDataArray:(BOOL)shouldForce;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView;
- (NSString *)cellIdentifier;


- (NSArray *)filteredArrayForSearchText:(NSString *)text inScope:(NSInteger)scope;
- (NSArray *)scopeButtonTitles;
- (NSString *)highlightedStringForScope;
- (NSInteger)currentScope;

@end
