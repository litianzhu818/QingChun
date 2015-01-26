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
#import "BaseNavigationController.h"
#import "UINavigationItem+Offset.h"
#import "UIBarButtonItem+SA.h"
#import <objc/runtime.h>
#import "ADTransitionController.h"

#define MARGIN_WIDTH 8.0f

@interface MeViewController ()<UserHeaderViewDelegate,NAMenuViewDelegate>

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NAMenuView *menuView;
@property (nonatomic, strong) UserHeaderView *userHeaderView;

@property (nonatomic, strong) UserInfoModel *userInfo;

@end

@implementation MeViewController
@synthesize userInfo;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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

- (void)dealloc
{
    [self removeNotifications];
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
    self.title = NSLocalizedString(@"我", @"me");
    [self.navigationItem addLeftBarButtonItem:[UIBarButtonItem barButtonItemWithImageName:@"send_msg" highLightedImageName:@"send_msg_highlighted" addTarget:self action:@selector(sendMessage:)]];
    
    [self.navigationItem addRightBarButtonItem:[UIBarButtonItem barButtonItemWithImageName:@"me_setting" highLightedImageName:@"send_setting_highlighted" addTarget:self action:@selector(setting:)]];
    
    userHeaderView = ({
        UserHeaderView *tempUserHeaderView = [UserHeaderView instanceFromNib];
        [tempUserHeaderView setFrame:CGRectMake(MARGIN_WIDTH, VIEW_BY(self.navigationController.navigationBar) + MARGIN_WIDTH, VIEW_W(self.view)-2*MARGIN_WIDTH, 44.0f)];
        [tempUserHeaderView setDelegate:self];
        [tempUserHeaderView setUserInteractionEnabled:YES];
        tempUserHeaderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin ;
        [self.view addSubview:tempUserHeaderView];
        tempUserHeaderView;
    });
    
    
    menuView = ({
        NAMenuView *tempMenuView = [[NAMenuView alloc] init];
        [tempMenuView setFrame:CGRectMake(MARGIN_WIDTH, VIEW_BY(self.userHeaderView), VIEW_W(self.view) - 2*MARGIN_WIDTH,VIEW_H(self.view) - VIEW_BY(self.userHeaderView) - VIEW_H(self.tabBarController.tabBar))];
        tempMenuView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
        tempMenuView.menuDelegate = self;
        [self.view addSubview:tempMenuView];
        tempMenuView;
    });

}

-(void)initializationData
{
    //Here initialization your data parameters
    [self setMenuItems:[self createMenuItems]];
    
    BOOL alreadyLogin = [[UserConfig sharedInstance] GetAlreadyLogin];
    
    if (alreadyLogin) {
        userInfo = [[UserConfig sharedInstance] GetUserInfo];
        [self.userHeaderView updateWithUserInfoModel:userInfo];
    }
    
    [self addNotifications];
}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"user_login_success" object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"user_login_success" object:nil];
}

- (void)receiveNotification:(NSNotification *)notification
{
    userInfo = [notification object] ? :[[UserConfig sharedInstance] GetUserInfo];
    [self.userHeaderView updateWithUserInfoModel:userInfo];
}

#pragma mark - Local Methods

- (NSArray *)createMenuItems
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserCenterMenuList" ofType:@"plist"];
    NSArray *menuArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    [menuArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        NAMenuItem *item = [[NAMenuItem alloc] initWithTitle:[dic objectForKey:@"name"]
                                                       image:[UIImage imageNamed:[dic objectForKey:@"imageName"]]
                                                     vcClass:NSClassFromString([dic objectForKey:@"className"])];
        [items addObject:item];
    }];
    
    return items;
}

- (void)sendMessage:(id)sender
{

}

- (void)setting:(id)sender
{

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
    /*
    CGRect sourceRect = [sender frame];
    sourceRect.origin.y = sourceRect.origin.y - self.tableView.contentOffset.y;
    
    ADTransition * transition = [[ADZoomTransition alloc] initWithSourceRect:CGRectMake(100, 100, 100, 100) andTargetRect:self.view.frame forDuration:0.25];
    ADTransitioningDelegate * transitioningDelegate = [[ADTransitioningDelegate alloc] initWithTransition:transition];
    
    viewController.transitioningDelegate = transitioningDelegate;
    */
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UserHeaderViewDelegate methods below
- (void)userHeaderView:(UserHeaderView *)userHeaderView didClikedOnButton:(UIButton *)button  hasUserInfo:(BOOL)hasUserInfo
{
    if (!hasUserInfo) {
        UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"login_register" bundle:nil];
        BaseNavigationController *loginViewController = [loginStory instantiateInitialViewController];
        
        [self.navigationController presentViewController:loginViewController animated:YES completion:^{
            
        }];
    }
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
