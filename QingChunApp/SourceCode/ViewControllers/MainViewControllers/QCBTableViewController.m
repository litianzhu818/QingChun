//
//  QCBTableViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 14-10-25.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "QCBTableViewController.h"
#import "MainHeaderView.h"
#import "MainHeaderViewItem.h"

#define MAIN_HEADER_VIEW_HEIGHT 64.0f

@interface QCBTableViewController ()<MainHeaderViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MainHeaderView *headerView;
    UITableView *tableView;
}
@end

@implementation QCBTableViewController

- (void)dealloc
{
    [headerView removeDelegate:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializationParameters];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializationParameters
{
    //Here initialization your parameters
    [self initializationUI];
    [self initializationData];
}

-(void)initializationUI
{
    //Here initialization your UI parameters
    
    NSArray *mainHeaderSelectedImages = [[NSArray alloc] initWithObjects:
                                     PNG_NAME(@"fabiao_selected.png"),
                                     PNG_NAME(@"jinghua_selected.png"),
                                     PNG_NAME(@"zuixin_selected.png"),
                                     PNG_NAME(@"shuaxin_selected.png"),
                                     nil];
    NSArray *mainHeaderUnselectedImages = [[NSArray alloc] initWithObjects:
                                       PNG_NAME(@"fabiao_normal.png"),
                                       PNG_NAME(@"jinghua_normal.png"),
                                       PNG_NAME(@"zuixin_normal.png"),
                                       PNG_NAME(@"shuaxin_normal.png"),
                                       nil];
    NSArray *mainHeaderTitles = [[NSArray alloc] initWithObjects:@"发表",@"精华",@"最新",@"刷新", nil];
    
    NSMutableArray *items = [NSMutableArray array];
    [mainHeaderTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MainHeaderViewItem *item = [[MainHeaderViewItem alloc] initWithTitle:obj normalImage:[mainHeaderSelectedImages objectAtIndex:idx] selectedImage:[mainHeaderUnselectedImages objectAtIndex:idx]];
        [items addObject:item];
    }];
    
    headerView = [[MainHeaderView alloc] initWithItems:items frame:CGRectMake(0, 0,VIEW_W(self.view) , MAIN_HEADER_VIEW_HEIGHT) delegate:self];
    [headerView setSelectedAtIndex:1];
    [headerView setBackgroundColor:[UIColor colorWithRed:218/255.0 green:2/255.0 blue:2/255.0 alpha:1.0]];
    [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:headerView];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_BY(headerView), VIEW_W(self.view), VIEW_H(self.view)) style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    NSMutableArray *Constraints = [NSMutableArray array];
    
    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-MARGIN1-[headerView]-MARGIN1-|"
                                                                             options:0
                                                                             metrics:@{
                                                                                       @"MARGIN1":@0.0}
                                                                               views:NSDictionaryOfVariableBindings(headerView)]];
    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-MARGIN1-[tableView]-MARGIN1-|"
                                                                             options:0
                                                                             metrics:@{
                                                                                       @"MARGIN1":@0.0}
                                                                               views:NSDictionaryOfVariableBindings(tableView)]];
    
    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-MARGIN1-[headerView(==MARGIN2)]-MARGIN1-[tableView]-MARGIN1-|"
                                                                             options:0
                                                                             metrics:@{
                                                                                       @"MARGIN1":@0.0,
                                                                                       @"MARGIN2":[NSNumber numberWithFloat:MAIN_HEADER_VIEW_HEIGHT]}
                                                                               views:NSDictionaryOfVariableBindings(headerView,tableView)]];
    [self.view addConstraints:Constraints];
}

-(void)initializationData
{
    //Here initialization your data parameters
}
- (void)didClikedAtFirstIndex
{
    LOG(@"FirstIndex");
}
- (void)didClikedAtLastIndex
{
    LOG(@"LastIndex");
}
- (void)MainHeaderView:(MainHeaderView *)mainHeaderView didSelectedAtIndex:(NSUInteger)index
{
    LOG(@"????:%d",index);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
