//
//  MeViewController.m
//  QingChunApp
//
//  Created by Peter Lee on 14/11/6.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "MeViewController.h"
#import "NAMenuView.h"
#import "UserHeaderView.h"
#import "MyPostsViewController.h"

#define MARGIN_WIDTH 8.0f

@interface MeViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NAMenuView *menuView;
@property (nonatomic, strong) UserHeaderView *userHeaderView;

@end

@implementation MeViewController
@synthesize menuView;
@synthesize menuItems;
@synthesize userHeaderView;

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
    [self initializationData];
    [self initializationUI];
}

-(void)initializationUI
{
    //Here initialization your UI parameters
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    userHeaderView = [[UserHeaderView alloc] initWithFrame:CGRectMake(MARGIN_WIDTH, VIEW_BY(self.navigationController.navigationBar) + MARGIN_WIDTH, VIEW_W(self.view)-2*MARGIN_WIDTH, 44.0f)];
    [self.view addSubview:userHeaderView];
    
    menuView = [[NAMenuView alloc] init];
    [menuView setFrame:CGRectMake(20, 128, 280, 280)];
    menuView.menuDelegate = self;
    [self.view addSubview:menuView];
}

-(void)initializationData
{
    //Here initialization your data parameters
    [self setMenuItems:[self createMenuItems]];
}
#pragma mark - Local Methods

- (NSArray *)createMenuItems {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    // First Item
    NAMenuItem *item1 = [[NAMenuItem alloc] initWithTitle:@"审核"
                                                    image:[UIImage imageNamed:@"check"]
                                                  vcClass:[MyPostsViewController class]];
    [items addObject:item1];
    
    // Second Item
    NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:@"活动"
                                                    image:[UIImage imageNamed:@"activities"]
                                                  vcClass:[MyPostsViewController class]];
    [items addObject:item2];
    
    // Third Item
    NAMenuItem *item3 = [[NAMenuItem alloc] initWithTitle:@"我的帖子"
                                                    image:[UIImage imageNamed:@"myPosts"]
                                                  vcClass:[MyPostsViewController class]];
    [items addObject:item3];
    
    // Fourth Item
    NAMenuItem *item4 = [[NAMenuItem alloc] initWithTitle:@"我的收藏"
                                                    image:[UIImage imageNamed:@"myCollections"]
                                                  vcClass:[MyPostsViewController class]];
    [items addObject:item4];
    
    // Fifth Item
    NAMenuItem *item5 = [[NAMenuItem alloc] initWithTitle:@"附近"
                                                    image:[UIImage imageNamed:@"nearby"]
                                                  vcClass:[MyPostsViewController class]];
    [items addObject:item5];
    
    // Sixth Item
    NAMenuItem *item6 = [[NAMenuItem alloc] initWithTitle:@"搜索"
                                                    image:[UIImage imageNamed:@"search"]
                                                  vcClass:[MyPostsViewController class]];
    [items addObject:item6];
    
    // Seventh Item
    NAMenuItem *item7 = [[NAMenuItem alloc] initWithTitle:@"最近热门"
                                                    image:[UIImage imageNamed:@"hot"]
                                                  vcClass:[MyPostsViewController class]];
    [items addObject:item7];
    
    // Eighth Item
    NAMenuItem *item8 = [[NAMenuItem alloc] initWithTitle:@"用户反馈"
                                                    image:[UIImage imageNamed:@"feedBack"]
                                                  vcClass:[MyPostsViewController class]];
    [items addObject:item8];
    
    // Ninth Item
    NAMenuItem *item9 = [[NAMenuItem alloc] initWithTitle:@"游戏中心"
                                                    image:[UIImage imageNamed:@"gameCenter"]
                                                  vcClass:[MyPostsViewController class]];
    [items addObject:item9];
    
    return items;
}


#pragma mark - NAMenuViewDelegate Methods

- (NSUInteger)menuViewNumberOfItems:(id)menuView {
    NSAssert([self menuItems], @"You must set menuItems before attempting to load.");
    return menuItems.count;
}

- (NAMenuItem *)menuView:(NAMenuView *)menuView itemForIndex:(NSUInteger)index {
    NSAssert([self menuItems], @"You must set menuItems before attempting to load.");
    return [menuItems objectAtIndex:index];
}

- (void)menuView:(NAMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index {
    NSAssert([self menuItems], @"You must set menuItems before attempting to load.");
    
    UIViewController *viewController;
    NAMenuItem *menuItem = [self.menuItems objectAtIndex:index];
    if (menuItem.storyboardName) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:menuItem.storyboardName  bundle:nil];
        viewController = [sb instantiateInitialViewController];
    } else {
        Class class = [menuItem targetViewControllerClass];
        viewController = [[class alloc] init];
    }
    [self.navigationController pushViewController:viewController animated:YES];
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
