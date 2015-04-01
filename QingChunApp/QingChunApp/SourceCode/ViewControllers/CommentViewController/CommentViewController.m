//
//  CommentViewController.m
//  QingChunApp
//
//  Created by Peter Lee on 15/3/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "CommentViewController.h"

#import "BaseNavigationController.h"
#import "CommentTableViewCell.h"
#import "HttpSessionManager.h"
#import "CellDisplayModel.h"
#import "CellCommentModel.h"
#import "MJRefresh.h"
#import "CommentInputBar.h"

static const NSString *readIdentifier = @"1";
static const NSString *addIdentifier = @"2";

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CommentInputBar *inputBar;
@property (strong, nonatomic) NSMutableArray *allComments;
@property (assign, nonatomic) NSUInteger currentPage;
@property (strong, nonatomic) CellDisplayModel *displayModel;

@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithModel:(id)model block:(void(^)(id object))block
{
    self = [super init];
    
    if (self) {
        self.displayModel = model;
        self.block = block;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializationParameters];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.alpha = 1.0;
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
    
    self.allComments = [NSMutableArray array];
    
    if (!self.tableView) {
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_BY(self.navigationController.navigationBar), self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-[CommentInputBar barHeight]) style:UITableViewStylePlain];
            
            tableView.delegate = self;
            tableView.dataSource = self;
            
            if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
                [tableView setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
                [tableView setLayoutMargins:UIEdgeInsetsZero];
            }

            [self clearUnusedCellWithTableView:tableView];
            //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [tableView setBackgroundColor:[UIColor clearColor]];
            
            //添加上拉下拉操作
            [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshAllData)];
            [tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadingMoreData)];
            
            // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
            [tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
            [tableView.header setTitle:@"松开立即刷新" forState:MJRefreshHeaderStatePulling];
            [tableView.header setTitle:@"获取数据中..." forState:MJRefreshHeaderStateRefreshing];
        
            [tableView.footer setTitle:@"加载数据中..." forState:MJRefreshFooterStateRefreshing];
            [tableView.footer setTitle:@"没有数据了..." forState:MJRefreshFooterStateNoMoreData];
            
            [tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:[CommentTableViewCell cellIdentifier]];
            [self.view addSubview:tableView];
            tableView;
        });
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (!self.inputBar) {
        self.inputBar = ({
            CommentInputBar *inputBar = [[CommentInputBar alloc] initWithPanGesture:self.tableView.panGestureRecognizer
                                                                             inView:self.view
                                                                            bgImage:[UIImage imageNamed:@"commnet-bar-bg"]
                                                                        placeHolder:@"说点什么吧..."
                                                                         hasSendBtn:YES
                                                                           btnTitle:nil
                                                                     btnNormalImage:[UIImage imageNamed:@"send-btn-bg"] btnhighlightedImage:nil
                                                                          sendBlock:^(NSString *messgae) {
                                                    
                                                                              // 发送信息
                                                                              [weakSelf sendMessageWithContent:messgae];
                                                                              
                                                                          }];
            [self.view addSubview:inputBar];

            inputBar;
        });
    }
}

- (void)clearUnusedCellWithTableView:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(void)initializationData
{
    //Here initialization your data parameters
    
    [self refreshAllData];
}

- (void)refreshAllData
{
    self.currentPage = 0;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //[params setObject:[[UserConfig sharedInstance] GetUserKey] forKey:@"userKey"];
    [params setObject:self.displayModel.cellContentModel.ID forKey:@"infoId"];
    [params setObject:[NSNumber numberWithUnsignedInteger:(self.currentPage + 1)] forKey:@"page"];
    
    __weak typeof(self) weakSelf = self;
    [[HttpSessionManager sharedInstance] readTweetCommentWithIdentifier:[NSString stringWithFormat:@"%@",readIdentifier]
                                                                 params:params
                                                                  block:^(id data, NSError *error) {
                                                                      if (!error) {
                                                                          
                                                                          [weakSelf.allComments removeAllObjects];
                                                                          [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                              CellCommentModel *model = [[CellCommentModel alloc] initWithDictionary:obj];
                                                                              [weakSelf.allComments addObject:model];
                                                                          }];
                                                                          
                                                                          ++_currentPage;
                                                                          [weakSelf.tableView reloadData];
                                                                      }else{
                                                                      
                                                                      }
                                                                      
                                                                      [weakSelf.tableView.header endRefreshing];
                                                                  }];
}
- (void)loadingMoreData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //[params setObject:[[UserConfig sharedInstance] GetUserKey] forKey:@"userKey"];
    [params setObject:self.displayModel.cellContentModel.ID forKey:@"infoId"];
    [params setObject:[NSNumber numberWithUnsignedInteger:(self.currentPage + 1)] forKey:@"page"];
    
    __weak typeof(self) weakSelf = self;
    [[HttpSessionManager sharedInstance] readTweetCommentWithIdentifier:[NSString stringWithFormat:@"%@",readIdentifier]
                                                                 params:params
                                                                  block:^(id data, NSError *error) {
                                                                      if (!error) {
                                                                          
                                                                          [weakSelf.tableView beginUpdates];
                                                                          
                                                                          [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                              
                                                                                                                                    [weakSelf.allComments addObject:obj];
                                                                              
                                                                              [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.allComments.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                                                                              
                                                                          }];
                                                                          
                                                                          [weakSelf.tableView endUpdates];
                                                                          ++_currentPage;
                                                                          
                                                                      }else{
                                                                      
                                                                      }
                                                                      
                                                                      [weakSelf.tableView.footer endRefreshing];
                                                                  }];
}

- (void)sendMessageWithContent:(NSString *)content
{
    // 如果未登录，必须先登录
    if (![self queryLoginState]) return;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.displayModel.cellContentModel.ID forKey:@"infoId"];
    [params setObject:[[UserConfig sharedInstance] GetUserKey] forKey:@"userKey"];
    [params setObject:content forKey:@"content"];
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpSessionManager sharedInstance] addTweetCommentWithIdentifier:[NSString stringWithFormat:@"%@",addIdentifier]
                                                                params:params
                                                                 block:^(id data, NSError *error) {
                                                                     if (error) {
                                                                         if (error.code == 2002) {
                                                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                                             message:@"您留言太频繁，请稍后再留言..."
                                                                                                                            delegate:nil
                                                                                                                   cancelButtonTitle:@"知道了"
                                                                                                                   otherButtonTitles:nil, nil];
                                                                             [alert show];
                                                                         }
                                                                     }else{
                                                                         // 插入新的cell
                                                                         
                                                                     }
                                                                 }];
}

// 查询登录状态，未登录就跳出登录选项
- (BOOL)queryLoginState
{
    BOOL hasLogin = NO;
    
    if ([[UserConfig sharedInstance] GetAlreadyLogin] && [[UserConfig sharedInstance] GetUserKey] != nil) {
        
        hasLogin = YES;
        
        return hasLogin;
    }
    
    UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"login_register" bundle:nil];
    BaseNavigationController *loginViewController = [loginStory instantiateInitialViewController];
    
    [self.navigationController presentViewController:loginViewController animated:YES completion:^{
        
    }];
    
    return hasLogin;
}

#pragma mark - <UITableViewDelegate> methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    CellCommentModel *model = [self.allComments objectAtIndex:indexPath.row];
    height += [CommentTableViewCell cellHeightWithModel:model];
    return height;
}

#pragma mark - <UITableViewDataSource> methods
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommentTableViewCell cellIdentifier] forIndexPath:indexPath];
    cell.commentModel = [self.allComments objectAtIndex:indexPath.row];
    
    return cell;
}

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
