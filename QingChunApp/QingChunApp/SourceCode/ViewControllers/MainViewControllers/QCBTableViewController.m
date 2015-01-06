//
//  QCBTableViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 14-10-25.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "QCBTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "UINavigationItem+Offset.h"
#import "UIBarButtonItem+SA.h"

#import "iCarousel.h"
#import "HMSegmentedControl.h"

#import "HttpSessionManager.h"
#import "MessageDisplayCell.h"
#import "CellDisplayModel.h"


@interface QCBTableViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,iCarouselDataSource, iCarouselDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;

    iCarousel           *_icarousel;
    HMSegmentedControl  *_segmentControl;
    UITableView         *_hotTableView;
    
    NSUInteger _currentPage;
    NSMutableArray *_newMsgs;
    NSMutableArray *_hotMsgs;
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

}

- (void)viewDidDisappear:(BOOL)animated
{

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
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        //segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
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
        iCarousel *icarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, VIEW_BY(self.navigationController.navigationBar), VIEW_W(self.view), VIEW_H(self.view)-VIEW_BY(self.navigationController.navigationBar)-VIEW_H(self.tabBarController.tabBar))];
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
    
    [self initTableView];
}

- (void)initTableView
{
    
    _tableView = ({
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:_icarousel.bounds style:UITableViewStylePlain];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView registerClass:[MessageDisplayCell class] forCellReuseIdentifier:[MessageDisplayCell cellIdentifier]];
        tableView;
    });
    
    _hotTableView = ({
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:_icarousel.bounds style:UITableViewStylePlain];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView registerClass:[MessageDisplayCell class] forCellReuseIdentifier:[MessageDisplayCell cellIdentifier]];
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
    _currentPage = 30;//The default value
    _newMsgs = [NSMutableArray array];
    _hotMsgs = [NSMutableArray array];

    [[HttpSessionManager sharedInstance] requestQCDMessageWithPage:(_currentPage + 1) type:1 identifier:[NSString stringWithFormat:@"%d",(_currentPage + 1)] block:^(id data, NSError *error) {
        
        if (!error) {
            _currentPage += 1;
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                   NSMakeRange(0,[(NSArray *)data count])];
            [_newMsgs insertObjects:data atIndexes:indexes];
            [_tableView reloadData];
        }
    
     }];
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
    return index == 0 ? _tableView:_hotTableView;
}

#pragma mark - iCarouselDelegate methods
- (void)carouselDidScroll:(iCarousel *)carousel
{
    if (_segmentControl) {
        
        float offset = carousel.scrollOffset;
        if (offset > 0) {
            [_segmentControl moveSelectionIndicatorWithScrollOffset:offset];
        }
    }
}
- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    if (_segmentControl) {
        [_segmentControl setSelectedSegmentIndex:carousel.currentItemIndex];
    }
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
    
    NSInteger result = 0;
    
    if ([tableView isEqual:_tableView]) {
        result = [_newMsgs count];
        //当列表数据为空时，需要去掉背景图片或者替换背景图片
        [_tableView setBackgroundView:(result == 0 ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage"]]:nil)];
        
        return result;
    }else{
        result = [_hotMsgs count];
        //当列表数据为空时，需要去掉背景图片或者替换背景图片
        [_hotTableView setBackgroundView:(result == 0 ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage"]]:nil)];
    
        return result;
    }
    
    return result;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:[MessageDisplayCell cellIdentifier] forIndexPath:indexPath];
    
    if ([tableView isEqual:_tableView]) {
        
        // Configure the cell...
        cell.cellDisPlayModel = [CellDisplayModel cellDisplayModelWithDictionary:[_newMsgs objectAtIndex:indexPath.row]];

    }else if ([tableView isEqual:_hotTableView]){
        
        // Configure the cell...
        cell.cellDisPlayModel = [CellDisplayModel cellDisplayModelWithDictionary:[_hotMsgs objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;

    if ([tableView isEqual:_tableView]) {
        height = [MessageDisplayCell cellFrameHeightWithWidth:(bound.size.width - 2*10) 
                                             cellDisplayModel:[CellDisplayModel cellDisplayModelWithDictionary:[_newMsgs objectAtIndex:indexPath.row]]];
    }else if ([tableView isEqual:_hotTableView]){
        height = [MessageDisplayCell cellFrameHeightWithWidth:(bound.size.width - 2*10)
                                             cellDisplayModel:[CellDisplayModel cellDisplayModelWithDictionary:[_hotMsgs objectAtIndex:indexPath.row]]];
    }
    
    return height;
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
