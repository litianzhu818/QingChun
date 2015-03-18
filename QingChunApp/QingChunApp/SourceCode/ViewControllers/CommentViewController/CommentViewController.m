//
//  CommentViewController.m
//  QingChunApp
//
//  Created by Peter Lee on 15/3/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "CommentViewController.h"

#import "CommentTableViewCell.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *allComments;

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
    
    self.allComments = [NSMutableArray array];
    
    if (!self.tableView) {
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-44) style:UITableViewStylePlain];
            
            tableView.delegate = self;
            tableView.dataSource = self;
            
            [tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:[CommentTableViewCell cellIdentifier]];
            
            tableView;
        });
    }
}

-(void)initializationData
{
    //Here initialization your data parameters
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
