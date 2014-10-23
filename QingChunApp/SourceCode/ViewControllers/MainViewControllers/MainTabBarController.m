//
//  MainTabBarController.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

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
    [self.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBar.opaque = YES;
    
    [self initTabBarImage];
    [self initTabBarText];
}

-(void)initializationData
{
    //Here initialization your data parameters
}

#pragma mark -
#pragma mark -  initTabBar

- (void)initTabBarText
{
    //Load TabBarText
    [self.tabBar.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITabBarItem *item = obj;
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:10],NSFontAttributeName, nil] forState:UIControlStateSelected];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:10],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [item setTitlePositionAdjustment:UIOffsetMake(0, -2)];
        
    }];
}

- (void)initTabBarImage
{
    //Load TabBarImage
    NSArray *tabBarSelectedImages = [[NSArray alloc] initWithObjects:
                                     PNG_NAME(@"qingchunba_selected.png"),
                                     PNG_NAME(@"qingchunqiang_selected.png"),
                                     PNG_NAME(@"qingchunmeng_selected.png"),
                                     PNG_NAME(@"me_selected.png"),
                                     nil];
    NSArray *tabBarUnselectedImages = [[NSArray alloc] initWithObjects:
                                       PNG_NAME(@"qingchunba_normal.png"),
                                       PNG_NAME(@"qingchunqiang_normal.png"),
                                       PNG_NAME(@"qingchunmeng_normal.png"),
                                       PNG_NAME(@"me_normal.png"),
                                       nil];
    NSAssert((self.tabBar.items.count == tabBarSelectedImages.count), @"The UITabBar Which In The MainTabBarViewController Selected Images Count Must Been Equal To The Count of The TabBar Items Count");
    NSAssert((self.tabBar.items.count == tabBarSelectedImages.count), @"The UITabBar Which In The MainTabBarViewController Unselected Images Count Must Been Equal To The Count of The TabBar Items Count");
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITabBarItem *item = obj;
        [item setImage:nil];
        [item setFinishedSelectedImage:[tabBarSelectedImages objectAtIndex:idx] withFinishedUnselectedImage:[tabBarUnselectedImages objectAtIndex:idx]];
    }];
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
