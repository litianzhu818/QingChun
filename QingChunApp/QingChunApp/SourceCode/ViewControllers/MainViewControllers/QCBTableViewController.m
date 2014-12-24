//
//  QCBTableViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 14-10-25.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "QCBTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "InfoTableViewCell.h"
#import "UINavigationItem+Offset.h"
#import "UIBarButtonItem+SA.h"

#import "iCarousel.h"
#import "HMSegmentedControl.h"


@interface QCBTableViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,iCarouselDataSource, iCarouselDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
    
    iCarousel           *_icarousel;
    HMSegmentedControl  *_segmentControl;
    UITableView         *_hotTableView;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

@implementation QCBTableViewController
@synthesize tableView = _tableView;

- (void)dealloc
{
    _refreshHeaderView = nil;
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

//    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
//    NSMutableArray *Constraints = [NSMutableArray array];
//    
//    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-MARGIN1-[_tableView]-MARGIN1-|"
//                                                                             options:0
//                                                                             metrics:@{
//                                                                                       @"MARGIN1":@0.0}
//                                                                               views:NSDictionaryOfVariableBindings(_tableView)]];
//    
//    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-MARGIN1-[_tableView]-MARGIN2-|"
//                                                                             options:0
//                                                                             metrics:@{
//                                                                                       @"MARGIN1":@64.0,
//                                                                                       @"MARGIN2":@44.0}
//                                                                               views:NSDictionaryOfVariableBindings(_tableView)]];
//    [self.view addConstraints:Constraints];
    
    self.title = @"青春吧";
    
    [self.navigationItem addLeftBarButtonItem:[UIBarButtonItem barButtonItemWithImageName:@"send_msg" highLightedImageName:@"send_msg_highlighted" addTarget:self action:@selector(sendMessage:)]];
    
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *refreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        refreshTableHeaderView.delegate = self;
        //refreshTableHeaderView.backgroundColor = [UIColor redColor];
        [self.view insertSubview:refreshTableHeaderView belowSubview:self.tableView];
        _refreshHeaderView = refreshTableHeaderView;
    
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    
    _segmentControl = ({
        // Segmented control with scrolling
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"最新", @"最热"]];
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        segmentedControl.frame = CGRectMake(0, 0, 200, 40);
        segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        //segmentedControl.shouldAnimateUserSelection = NO;
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segmentedControl.font = [UIFont systemFontOfSize:17.0];
        segmentedControl.selectionIndicatorHeight = 2.0f;
        segmentedControl.backgroundColor = [UIColor clearColor];
        segmentedControl.textColor = UIColorFromRGB(0x757575);
        segmentedControl.selectedTextColor = UIColorFromRGB(0x61a653);
        segmentedControl.selectionIndicatorColor = UIColorFromRGB(0x61a653);
        /*//The block
        [segmentedControl setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"Selected index %ld (via block)", (long)index);
        }];
         */
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segmentedControl;
        segmentedControl;
    });
    
    _icarousel = ({
        iCarousel *icarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 64, 320, 480-64)];
        icarousel.dataSource = self;
        icarousel.delegate = self;
        icarousel.decelerationRate = 1.0;
        icarousel.scrollSpeed = 1.0;
        icarousel.type = iCarouselTypeLinear;
        icarousel.pagingEnabled = YES;
        icarousel.clipsToBounds = YES;
        icarousel.bounceDistance = 0.2;
        [self.view addSubview:icarousel];
        icarousel;
    });

}

- (void)initTableView
{
    
    _tableView = ({
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:_icarousel.bounds style:UITableViewStylePlain];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setBackgroundColor:[UIColor clearColor]];
        //[self.view addSubview:self.tableView];
        
        tableView;
    });
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [_icarousel setCurrentItemIndex:segmentedControl.selectedSegmentIndex];
}


-(void)initializationData
{
    //Here initialization your data parameters
}

- (IBAction)sendMessage:(id)sender
{

}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return [NSDate date]; // should return date data source was last changed
    
}

//#pragma mark - iCarousel
#pragma mark iCarouselDataSource methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 2;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    _tableView = ({
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:carousel.bounds style:UITableViewStylePlain];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setBackgroundColor:[UIColor clearColor]];
        //[self.view addSubview:self.tableView];
        
        tableView;
    });

    return _tableView;
}

#pragma mark - iCarouselDelegate methods
- (void)carouselDidScroll:(iCarousel *)carousel
{
    if (_segmentControl) {
        
        float offset = carousel.scrollOffset;
        
        [_segmentControl drawSelectionIndicatorByOffsetPercent:offset];
        
        NSLog(@"Value:%f",offset);
//        if (offset > 0) {
//            
//           [_segmentControl drawSelectionIndicatorByOffsetPercent:offset];
//        }
    }
}
- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    if (_segmentControl) {
        [_segmentControl setSelectedSegmentIndex:carousel.currentItemIndex];
    }
//    ProjectListView *curView = (ProjectListView *)carousel.currentItemView;
//    [curView refreshToQueryData];
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
