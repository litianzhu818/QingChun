//
//  BaseNavigationController.m
//  Kissnapp
//
//  Created by Peter Lee on 14/10/16.
//  Copyright (c) 2014年 AFT. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@property(readonly, nonatomic) UIViewController *activeViewController;
@property(readonly, nonatomic) UIViewController *destinationViewController;

@end

@implementation BaseNavigationController

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
}

-(void)initializationData
{
    //Here initialization your data parameters
}

-(UIViewController *)activeViewController
{
    return [super topViewController];
}

-(UIViewController *)destinationViewController
{
    return ([super.viewControllers count] > 2) ? (UIViewController *)([super.viewControllers objectAtIndex:([super.viewControllers count] - 2)]):nil;
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    if ([viewControllers isEqualToArray:super.viewControllers]) {
        return;
    }
    [super setViewControllers:viewControllers];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    LOG(@"The Current ViewController:%@\nThe Destination ViewController:%@",NSStringFromClass([self.topViewController class]),NSStringFromClass([viewController class]));
    
    if (self.activeViewController && ![[self.activeViewController class] isEqual:[viewController class]]){
        [super pushViewController:viewController animated:animated];
    }
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.activeViewController && ![[self.activeViewController class] isEqual:[viewController class]]){
        return [super popToViewController:viewController animated:animated];
    }
    
    return @[];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.activeViewController && ![[self.activeViewController class] isEqual:[self.destinationViewController class]]){
        return [super popViewControllerAnimated:animated];
    }
    
    return nil;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (self.activeViewController && ![self.activeViewController isEqual:[self.viewControllers firstObject]]){
        return [super popToRootViewControllerAnimated:animated];
    }
    
    return @[];
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
