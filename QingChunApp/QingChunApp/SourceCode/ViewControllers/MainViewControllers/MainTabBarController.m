//
//  MainTabBarController.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "MainTabBarController.h"
#import "UITabBar+BackgroundImage.h"

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
    [self setBagroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBar"]]];
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
    //get the selected picture color
    UIFont  *tabBarFont     =   [UIFont boldSystemFontOfSize:10];
    UIColor *selectedColor  =   UIColorFromRGB(0x61a653);
    UIColor *normalColor    =   UIColorFromRGB(0x757575);
    
    [self.tabBar setTabBarItemsTitleNormalColor:normalColor
                                     normalFont:tabBarFont
                                  selectedColor:selectedColor
                                   selectedFont:tabBarFont
                             positionAdjustment:UIOffsetMake(0, -2)];
}

- (void)initTabBarImage
{
    //Load TabBarImage
    NSArray *tabBarSelectedImages = [[NSArray alloc] initWithObjects:
                                     PNG_NAME(@"qingchunba_selected.png"),
                                     PNG_NAME(@"qingchunbell_selected.png"),
                                     PNG_NAME(@"qingchungroup_selected.png"),
                                     PNG_NAME(@"me_selected.png"),
                                     nil];
    NSArray *tabBarUnselectedImages = [[NSArray alloc] initWithObjects:
                                       PNG_NAME(@"qingchunba_normal.png"),
                                       PNG_NAME(@"qingchunbell_normal.png"),
                                       PNG_NAME(@"qingchungroup_normal.png"),
                                       PNG_NAME(@"me_normal.png"),
                                       nil];
    NSAssert((self.tabBar.items.count == tabBarSelectedImages.count), @"The UITabBar Which In The MainTabBarViewController Selected Images Count Must Been Equal To The Count of The TabBar Items Count");
    NSAssert((self.tabBar.items.count == tabBarSelectedImages.count), @"The UITabBar Which In The MainTabBarViewController Unselected Images Count Must Been Equal To The Count of The TabBar Items Count");
    
    [self.tabBar setTabBarItemsNormalImages:tabBarUnselectedImages selectedImages:tabBarSelectedImages];
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
