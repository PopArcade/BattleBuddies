//
//  BBItemListViewController.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBItemListViewController.h"
#import "BBDatabase.h"
#import "BBItemCell.h"
#import "BBItem.h"

@interface BBItemListViewController ()

@end

@implementation BBItemListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.itemBackPackTableView];
}


#pragma mark Views

- (UITableView *)itemBackPackTableView
{
    if (!_itemBackPackTableView) {
        
        _itemBackPackTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        [_itemBackPackTableView setDelegate:self];
        [_itemBackPackTableView setDataSource:self];
    }
    return _itemBackPackTableView;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[BBDatabase itemsInBackpack] count];
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BBItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[BBItemCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
//    RWTScaryBugDoc *bug = [self.bugs objectAtIndex:indexPath.row];
    BBItem *item = [[BBDatabase itemsInBackpack] objectAtIndex:indexPath.row];
    cell.itemName.text = item.name;
    cell.itemImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:item.imageURL]];
    
    [cell.contentView addSubview:cell.itemImage];
    [cell.contentView addSubview:cell.itemName];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
