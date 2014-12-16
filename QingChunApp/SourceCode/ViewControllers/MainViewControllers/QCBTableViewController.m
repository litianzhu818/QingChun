//
//  QCBTableViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 14-10-25.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "QCBTableViewController.h"
#import "InfoTableViewCell.h"
#import "UINavigationItem+Offset.h"


@interface QCBTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
}

@end

@implementation QCBTableViewController
@synthesize tableView = _tableView;

- (void)dealloc
{
}
- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [self.navigationController.navigationBar setHidden:NO];
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
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    NSMutableArray *Constraints = [NSMutableArray array];
    
    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-MARGIN1-[_tableView]-MARGIN1-|"
                                                                             options:0
                                                                             metrics:@{
                                                                                       @"MARGIN1":@0.0}
                                                                               views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-MARGIN1-[_tableView]-MARGIN2-|"
                                                                             options:0
                                                                             metrics:@{
                                                                                       @"MARGIN1":@64.0,
                                                                                       @"MARGIN2":@44.0}
                                                                               views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:Constraints];
    
    self.title = @"青春吧";
    [self.navigationItem addLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fabiao_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage:)]];
}

-(void)initializationData
{
    //Here initialization your data parameters
}

- (IBAction)sendMessage:(id)sender
{

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = cell = [InfoTableViewCell instanceFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"cell_bg"];
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [cell setBackgroundView:imageView];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    // Configure the cell...x
//    for (UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 368;
}
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
