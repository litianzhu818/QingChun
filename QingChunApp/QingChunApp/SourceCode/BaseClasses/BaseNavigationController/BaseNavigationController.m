//
//  BaseNavigationController.m
//  Kissnapp
//
//  Created by Peter Lee on 14/10/16.
//  Copyright (c) 2014年 AFT. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationBar+ImageBackground.h"

// 判断是否为iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface BaseNavigationController ()

@property(readonly, nonatomic) UIViewController *activeViewController;
@property(readonly, nonatomic) UIViewController *destinationViewController;

@end

@implementation BaseNavigationController


#pragma mark 一个类只会调用一次
/*
+ (void)initialize
{
    // 1.取出设置主题的对象
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    NSString *navigationBarBackImageName = nil;
    if (iOS7) { // iOS7
        navigationBarBackImageName = @"navigationBar.png";
        navigationBar.tintColor = UIColorFromRGB(0x757575);
    } else { // 非iOS7
        navigationBarBackImageName = @"navigationBar";
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    }

    [navigationBar setVerticalBackgroundImage:[UIImage imageNamed:navigationBarBackImageName]
               landscapeBackgroundImage:nil
                         withShadowLine:NO];
    
    // 3.标题
    [navigationBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : UIColorFromRGB(0x757575)
                                     }];
    
}
*/
#pragma mark 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


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
    //设置导航栏的字体颜色和背景图片
    [self.navigationBar setVerticalBackgroundImage:[UIImage imageNamed:@"navigationBar"]
                          landscapeBackgroundImage:nil
                                    withShadowLine:NO];
    self.navigationBar.tintColor = UIColorFromRGB(0x757575);
    /*
    [self.navigationBar setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : UIColorFromRGB(0x757575)
                                            }];
     */
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
