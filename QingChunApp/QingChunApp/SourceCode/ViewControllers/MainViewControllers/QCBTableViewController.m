//
//  QCBTableViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 14-10-25.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "QCBTableViewController.h"
#import "UINavigationItem+Offset.h"
#import "UIBarButtonItem+SA.h"
#import "MJRefresh.h"
#import "iCarousel.h"
#import "HMSegmentedControl.h"

#import "HttpSessionManager.h"
#import "MessageDisplayCell.h"
#import "CellDisplayModel.h"

#import "CommentViewController.h"

#import "EGOCache.h"

#define QCB_NEW_DATA_CACHE_KEY_STRING @"QCBTableViewNewSourceKey"
#define QCB_HOT_DATA_CACHE_KEY_STRING @"QCBTableViewHotSourceKey"

typedef NS_ENUM(NSUInteger, CacheDataType) {
    CacheDataTypeNew = 0,
    CacheDataTypeHot
};

@interface QCBTableViewController ()<UITableViewDataSource,UITableViewDelegate,iCarouselDataSource, iCarouselDelegate>
{
    iCarousel           *_icarousel;
    HMSegmentedControl  *_segmentControl;
    UITableView         *_hotTableView;
    
    NSUInteger _currentPage;
    NSMutableArray *_newMsgs;
    NSMutableArray *_hotMsgs;
    
    NSUInteger _currentTableViewIndex;
    NSMutableArray *_tableViewFirstLoadingStatuss;
    NSMutableArray *_tableViewHasLoadingData;
    
    NSMutableArray *_tableViewCurrentPages;
    
}

@end

@implementation QCBTableViewController
@synthesize tableView = _tableView;

- (void)dealloc
{
    [_newMsgs removeAllObjects];
    [_hotMsgs removeAllObjects];
    [_tableViewFirstLoadingStatuss removeAllObjects];
    [_tableViewCurrentPages removeAllObjects];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    /*
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
     */
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
    
    _segmentControl = ({
        // Segmented control with scrolling
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"广场", @"精华"]];
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
        iCarousel *icarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, VIEW_W(self.view), VIEW_H(self.view))];
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
        //要么没有分割线，要么风格线是和屏幕一样宽的
        //设置没有分割线
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        /*
        //风格线是和屏幕一样宽
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        */
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView registerClass:[MessageDisplayCell class] forCellReuseIdentifier:[MessageDisplayCell cellIdentifier]];
        
        tableView.contentInset = UIEdgeInsetsMake(64, 0, -44, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, -44, 0);
        
        //添加上拉下拉操作
        [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshQCBData) dateKey:@"QCB_tableview_refresh_time_tag"];
        [tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadingMoreQCBData)];
        
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        [tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
        [tableView.header setTitle:@"松开立即刷新" forState:MJRefreshHeaderStatePulling];
        [tableView.header setTitle:@"获取数据中..." forState:MJRefreshHeaderStateRefreshing];
        
        [tableView.footer setTitle:@"加载数据中..." forState:MJRefreshFooterStateRefreshing];
        [tableView.footer setTitle:@"没有数据了..." forState:MJRefreshFooterStateNoMoreData];
        
        tableView;
    });
    
    _hotTableView = ({
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:_icarousel.bounds style:UITableViewStylePlain];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        //要么没有分割线，要么风格线是和屏幕一样宽的
        //设置没有分割线
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        /*
        //风格线是和屏幕一样宽
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        */
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView registerClass:[MessageDisplayCell class] forCellReuseIdentifier:[MessageDisplayCell cellIdentifier]];
        
        tableView.contentInset = UIEdgeInsetsMake(64, 0, -44, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, -44, 0);
        
        //添加上拉下拉操作
        [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshQCBHotData) dateKey:@"QCB_hot_tableview_refresh_time_tag"];
        [tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadingMoreQCBHotData)];
        
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        [tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
        [tableView.header setTitle:@"松开立即刷新" forState:MJRefreshHeaderStatePulling];
        [tableView.header setTitle:@"获取数据中..." forState:MJRefreshHeaderStateRefreshing];
        
        [tableView.footer setTitle:@"加载数据中..." forState:MJRefreshFooterStateRefreshing];
        [tableView.footer setTitle:@"没有数据了..." forState:MJRefreshFooterStateNoMoreData];
        
        tableView;
    });
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    _currentTableViewIndex = segmentedControl.selectedSegmentIndex;
    
    if (_icarousel.currentItemIndex != segmentedControl.selectedSegmentIndex) {
        [_icarousel setCurrentItemIndex:segmentedControl.selectedSegmentIndex];
    }
    
    if ([(NSNumber *)[_tableViewFirstLoadingStatuss objectAtIndex:1] boolValue]) return;
    
    [_hotTableView headerBeginRefreshing];
}

- (void)cacheListDataWithType:(CacheDataType)cacheType data:(id)data
{
    NSString *cacheKey = nil;
    
    if (cacheType == CacheDataTypeHot) {
        cacheKey = QCB_HOT_DATA_CACHE_KEY_STRING;
    }else if (cacheType == CacheDataTypeNew){
        cacheKey = QCB_NEW_DATA_CACHE_KEY_STRING;
    }
    
    [[EGOCache globalCache] setObject:data forKey:cacheKey];
}

- (void)initTableViewDataSourceFromCache
{
    _newMsgs = [NSMutableArray arrayWithArray:(NSArray *)[[EGOCache globalCache] objectForKey:QCB_NEW_DATA_CACHE_KEY_STRING]];
    _hotMsgs = [NSMutableArray arrayWithArray:(NSArray *)[[EGOCache globalCache] objectForKey:QCB_HOT_DATA_CACHE_KEY_STRING]];
    
    [_tableView reloadData];
    [_hotTableView reloadData];
}


- (void)refreshQCBData
{
    __block NSUInteger currentQCBDataPage = 0;
    
    
    [[HttpSessionManager sharedInstance] requestQCDMessageWithPage:(currentQCBDataPage + 1) type:3 identifier:[NSString stringWithFormat:@"%u",(currentQCBDataPage + 1)] block:^(id data, NSError *error) {
        
        if (!error) {
            [_newMsgs removeAllObjects];
            currentQCBDataPage += 1;
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                   NSMakeRange(0,[(NSArray *)data count])];
            [_newMsgs insertObjects:data atIndexes:indexes];
            [_tableView reloadData];
            
            [_tableViewCurrentPages replaceObjectAtIndex:0 withObject:[NSNumber numberWithUnsignedInteger:currentQCBDataPage]];
            
            [self cacheListDataWithType:CacheDataTypeNew data:data];
            
            if (![(NSNumber *)[_tableViewHasLoadingData objectAtIndex:0] boolValue]) {
                [_tableViewHasLoadingData replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
            }
        }
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView.header endRefreshing];
        
        if (![(NSNumber *)[_tableViewFirstLoadingStatuss objectAtIndex:0] boolValue]) {
            [_tableViewFirstLoadingStatuss replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
        }
    
    }];
}


- (void)loadingMoreQCBData
{
    __block NSUInteger currentQCBDataPage = [(NSNumber *)[_tableViewCurrentPages objectAtIndex:0] unsignedIntegerValue];
    
    [[HttpSessionManager sharedInstance] requestQCDMessageWithPage:(currentQCBDataPage + 1) type:3 identifier:[NSString stringWithFormat:@"%u",(currentQCBDataPage + 1)] block:^(id data, NSError *error) {
        
        
        
        if (!error) {
            
            currentQCBDataPage += 1;
            
            [_tableView beginUpdates];
            
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [_newMsgs addObject:obj];
                
                [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_newMsgs.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                
            }];
            
            [_tableView endUpdates];
            
            [_tableViewCurrentPages replaceObjectAtIndex:0 withObject:[NSNumber numberWithUnsignedInteger:currentQCBDataPage]];
        }
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView.footer endRefreshing];
        
    }];
}

- (void)refreshQCBHotData
{
    __block NSUInteger currentQCBHotDataPage = 0;
    
    
    [[HttpSessionManager sharedInstance] requestQCDMessageWithPage:(currentQCBHotDataPage + 1) type:1 identifier:[NSString stringWithFormat:@"%u",(currentQCBHotDataPage + 1)] block:^(id data, NSError *error) {
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_hotTableView.header endRefreshing];
        
        if (!error) {
            
            currentQCBHotDataPage += 1;
            
            [_tableViewCurrentPages replaceObjectAtIndex:1 withObject:[NSNumber numberWithUnsignedInteger:currentQCBHotDataPage]];
            
             
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                   NSMakeRange(0,[(NSArray *)data count])];
            [_hotMsgs removeAllObjects];
            [_hotMsgs insertObjects:data atIndexes:indexes];
            
            [_hotTableView reloadData];
            
            [self cacheListDataWithType:CacheDataTypeHot data:data];
    
            if (![(NSNumber *)[_tableViewHasLoadingData objectAtIndex:1] boolValue]) {
                [_tableViewHasLoadingData replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
            }
        }
        
        if (![(NSNumber *)[_tableViewFirstLoadingStatuss objectAtIndex:1] boolValue]) {
            [_tableViewFirstLoadingStatuss replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
        }
    }];

}

- (void)loadingMoreQCBHotData
{
    __block NSUInteger currentQCBHotDataPage = [(NSNumber *)[_tableViewCurrentPages objectAtIndex:1] unsignedIntegerValue];
    
    [[HttpSessionManager sharedInstance] requestQCDMessageWithPage:(currentQCBHotDataPage + 1) type:1 identifier:[NSString stringWithFormat:@"%u",(currentQCBHotDataPage + 1)] block:^(id data, NSError *error) {
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_hotTableView.footer endRefreshing];
        
        if (!error) {
            
            currentQCBHotDataPage += 1;
            
            [_hotTableView beginUpdates];
            
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [_hotMsgs addObject:obj];
                
                [_hotTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_hotMsgs.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                
            }];
            
            [_hotTableView endUpdates];
            
            [_tableViewCurrentPages replaceObjectAtIndex:1 withObject:[NSNumber numberWithUnsignedInteger:currentQCBHotDataPage]];
        }
        
    }];
}


-(void)initializationData
{
    //Here initialization your data parameters
    _currentTableViewIndex = 0;
    _currentPage = 30;//The default value
    [self initTableViewDataSourceFromCache];
    
    _tableViewFirstLoadingStatuss = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO], nil];
    _tableViewCurrentPages = [NSMutableArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:0],[NSNumber numberWithUnsignedInteger:0], nil];
    _tableViewHasLoadingData = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil];
    
    //开始刷新第一个UITableView数据
    [_tableView headerBeginRefreshing];
}

- (IBAction)sendMessage:(id)sender
{

}
#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //Selected index's color changed.
    if (scrollView.contentSize.height <= CGRectGetHeight(scrollView.bounds)-50) {
        [self hideToolBar:NO];
        return;
    }
    static float newY = 0;
    static float oldY = 0;
    newY= scrollView.contentOffset.y;
    if (ABS(newY - oldY) > 50) {
        if (newY > oldY && newY > 1) {
            [self hideToolBar:YES];
        }else if(newY < oldY ){
            [self hideToolBar:NO];
        }
        oldY = newY;
    }
}

- (void)hideToolBar:(BOOL)hide
{
    if (hide == self.tabBarController.tabBar.hidden) return;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake((hide ? 0.0:64.0), 0.0, (hide ? 0.0:-44.0), 0.0);
    
    CGFloat apha = (hide ? 0.0:1.0);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _tableView.contentInset = contentInsets;
        _tableView.scrollIndicatorInsets = contentInsets;
        
        _hotTableView.contentInset = contentInsets;
        _hotTableView.scrollIndicatorInsets = contentInsets;
        
        self.navigationController.navigationBar.alpha = apha;
        
    } completion:^(BOOL finished) {
        
        [self.tabBarController.tabBar setHidden:hide];
        
    }];
    
    //self.navigationController.hidesBarsOnSwipe = !hide;
}


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
    
    __weak typeof(self) weakSelf = self;
    cell.commentBlock =  ^(id model){
        CommentViewController *commentController = [[CommentViewController alloc] initWithModel:model
                                                                                          block:^(id object) {
                                                                                              
                                                                                          }];
        [weakSelf.navigationController pushViewController:commentController animated:YES];
    };

    
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
