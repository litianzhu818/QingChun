//
//  BaseTabBarController.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()
{
    UIView *backgroundView;
}
@end

@implementation BaseTabBarController

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
    [self initParameters];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initParameters
{
    //Here initialization your parameters
    [self initUI];
    [self initData];
}

-(void)initUI
{
    //Here initialization your UI parameters
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tabBar.frame.size.width,self.tabBar.frame.size.height)];
    backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    backgroundView.backgroundColor = [UIColor clearColor];
    
    [self.tabBar insertSubview:backgroundView atIndex:(IOS7_OR_LATER) ? 0 : 1];
 
}

-(void)initData
{
    //Here initialization your data parameters
}

- (void)setBagroundColor:(UIColor *)color
{
    [backgroundView setBackgroundColor:color];
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
