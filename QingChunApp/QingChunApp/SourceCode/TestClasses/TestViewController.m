//
//  TestViewController.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "TestViewController.h"
//#import "MainHeaderViewCell.h"
#import "MainHeaderViewItem.h"
#import "MainHeaderView.h"

@interface TestViewController ()<MainHeaderViewDelegate>

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
   }

-(void)initializationData
{
    //Here initialization your data parameters
}

-(IBAction)ClikedOnOkButton:(id)sender
{
    [self performSegueWithIdentifier:@"test1" sender:nil];
}

- (void)MainHeaderView:(MainHeaderView *)mainHeaderView didSelectedAtIndex:(NSUInteger)index
{
    LOG(@"选中的是:%ld",index);
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
