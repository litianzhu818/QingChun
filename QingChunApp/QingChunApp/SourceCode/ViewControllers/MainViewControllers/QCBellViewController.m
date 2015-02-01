//
//  QCBellViewController.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/9.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "QCBellViewController.h"
#import "QCBellTableViewCell.h"
#import "QCBellDataModel.h"
#import "QingChunBellModel.h"
#import "UserInfoModel.h"
#import "MJRefresh.h"
#import "HttpSessionManager.h"

@interface QCBellViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dateSources;
    UserInfoModel *_userInfo;
    QingChunBellModel *_qingChunBellModel;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QCBellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializationParameters];
    
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
    self.title = @"青春风铃";
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_BY(self.navigationController.navigationBar), VIEW_W(self.view), VIEW_H(self.view)-VIEW_H(self.navigationController.navigationBar)-VIEW_H(self.tabBarController.tabBar)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[QCBellTableViewCell class] forCellReuseIdentifier:[QCBellTableViewCell CellIdentifier]];
        
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self clearUnusedCellWithTableView:tableView];
        
        [self.view addSubview:tableView];
        
        //添加上拉下拉操作
        [tableView addHeaderWithTarget:self action:@selector(refreshNumberData) dateKey:@"qingchun_bell_tableview_refresh_time_tag"];
        //[tableView addFooterWithTarget:self action:@selector(refreshNumberData)];
        
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        tableView.headerPullToRefreshText = @"下拉刷新青春风铃数据";
        tableView.headerReleaseToRefreshText = @"松开立即刷新";
        tableView.headerRefreshingText = @"刷新青春风铃数据中...";
        
        tableView;
    });
}

-(void)initializationData
{
    //Here initialization your data parameters
    _qingChunBellModel = [QingChunBellModel qingChunBellModel];
    _dateSources = [self createDataSources];
    
}

- (void)refreshNumberData
{
    _userInfo = [[UserConfig sharedInstance] GetUserInfo];
    if (_userInfo) {
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_userInfo.userID forKey:@"infoId"];
        [dic setObject:[[UserConfig sharedInstance] GetUserKey] forKey:@"userKey "];
        
        [[HttpSessionManager sharedInstance] requsetBellNumberWithIdentifier:@"qcd_bell"
                                                                      params:dic
                                                                       block:^(id data, NSError *error) {
                                                                           
                                                                           // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                                                                           [_tableView headerEndRefreshing];
                                                                           
                                                                           if (!error) {
                                                                               [_qingChunBellModel updateWithDictionary:data];
                                                                               [self createDataSources];
                                                                               MAIN_GCD(^{
                                                                                   [self.tableView reloadData];
                                                                               });
                                                                           }
                                                                           
                                                                       }];
    }
}

- (NSMutableArray *)createDataSources
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QCBellInfoMsg" ofType:@"plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSDictionary *dic0 = [dataArray firstObject];
    QCBellDataModel *item0 = [QCBellDataModel qcbellDataModelWithImage:[UIImage imageNamed:[dic0 objectForKey:@"image"]]
                                                                title:[dic0 objectForKey:@"title"]
                                                               number:_qingChunBellModel.atNumber
                                                                  tag:[[dic0 objectForKey:@"tag"] unsignedIntegerValue]];
    [items addObject:item0];
    
    NSDictionary *dic1 = [dataArray objectAtIndex:1];
    QCBellDataModel *item1 = [QCBellDataModel qcbellDataModelWithImage:[UIImage imageNamed:[dic1 objectForKey:@"image"]]
                                                                 title:[dic1 objectForKey:@"title"]
                                                                number:_qingChunBellModel.atNumber
                                                                   tag:[[dic1 objectForKey:@"tag"] unsignedIntegerValue]];
    [items addObject:item1];
    
    NSDictionary *dic2 = [dataArray objectAtIndex:2];
    QCBellDataModel *item2 = [QCBellDataModel qcbellDataModelWithImage:[UIImage imageNamed:[dic2 objectForKey:@"image"]]
                                                                 title:[dic2 objectForKey:@"title"]
                                                                number:_qingChunBellModel.atNumber
                                                                   tag:[[dic2 objectForKey:@"tag"] unsignedIntegerValue]];
    [items addObject:item2];
    
    NSDictionary *dic3 = [dataArray objectAtIndex:3];
    QCBellDataModel *item3 = [QCBellDataModel qcbellDataModelWithImage:[UIImage imageNamed:[dic3 objectForKey:@"image"]]
                                                                 title:[dic3 objectForKey:@"title"]
                                                                number:_qingChunBellModel.atNumber
                                                                   tag:[[dic3 objectForKey:@"tag"] unsignedIntegerValue]];
    [items addObject:item3];
    
    /*
    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        QCBellDataModel *item = [QCBellDataModel qcbellDataModelWithImage:[UIImage imageNamed:[dic objectForKey:@"image"]]
                                                                    title:[dic objectForKey:@"title"]
                                                                   number:10
                                                                      tag:[[dic objectForKey:@"tag"] unsignedIntegerValue]];
        [items addObject:item];
    }];
     */
    
    return items;
}

- (void)clearUnusedCellWithTableView:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dateSources count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QCBellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QCBellTableViewCell CellIdentifier] forIndexPath:indexPath];
    QCBellDataModel *qcBellDataModel = [_dateSources objectAtIndex:indexPath.row];
    cell.qcbellDataModel = qcBellDataModel;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QCBellTableViewCell CellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
