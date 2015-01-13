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

@interface QCBellViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dateSources;
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
        tableView;
    });
}

-(void)initializationData
{
    //Here initialization your data parameters
    _dateSources = [self createDataSources];
    
}


- (NSMutableArray *)createDataSources
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QCBellInfoMsg" ofType:@"plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        QCBellDataModel *item = [QCBellDataModel qcbellDataModelWithImage:[UIImage imageNamed:[dic objectForKey:@"image"]]
                                                                    title:[dic objectForKey:@"title"]
                                                                   number:10
                                                                      tag:[[dic objectForKey:@"tag"] unsignedIntegerValue]];
        [items addObject:item];
    }];
    
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
