//
//  TestViewController.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "TestViewController.h"
#import "MainHeaderViewCell.h"
#import "MainHeaderViewItem.h"
#import "MainHeaderView.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
//    self.title = @"123";
//    [self.view setBackgroundColor:[UIColor redColor]];
//    UITabBar *bar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, 400, 30)];
//    UITabBarItem *baItem1 = [[UITabBarItem alloc] initWithTitle:@"李天柱" image:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
//    
//    UITabBarItem *baItem2 = [[UITabBarItem alloc] initWithTitle:@"Peter Lee" image:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
//    
//    [bar setItems:[NSArray arrayWithObjects:baItem1,baItem2, nil]];
//    [bar setBackgroundColor:[UIColor lightGrayColor]];
//    
//    [self.navigationItem setTitleView:bar];
//    [self.view addSubview:bar];
//    LOG(NSStringFromCGRect(bar.frame));
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setHidden:YES];
    MainHeaderViewItem *item1 = [[MainHeaderViewItem alloc] initWithTitle:@"李天柱" normalImage:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
    
    
    MainHeaderViewItem *item2 = [[MainHeaderViewItem alloc] initWithTitle:@"李天柱" normalImage:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
    
    MainHeaderViewItem *item3 = [[MainHeaderViewItem alloc] initWithTitle:@"李天柱" normalImage:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
    
    
    MainHeaderViewItem *item4 = [[MainHeaderViewItem alloc] initWithTitle:@"李天柱" normalImage:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
    
    MainHeaderViewItem *item5 = [[MainHeaderViewItem alloc] initWithTitle:@"李天柱" normalImage:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
    
    
    MainHeaderViewItem *item6 = [[MainHeaderViewItem alloc] initWithTitle:@"李天柱" normalImage:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
    MainHeaderView *view = [[MainHeaderView alloc] initWithItems:[NSArray arrayWithObjects:item1,item2,item3,item4,item5,item6, nil] frame:CGRectMake(0, 0, VIEW_W(self.view), 64.0) delegate:self];
    [view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view];
    

    
}

-(void)initializationData
{
    //Here initialization your data parameters
}

-(IBAction)ClikedOnOkButton:(id)sender
{
    [self performSegueWithIdentifier:@"test1" sender:nil];
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
