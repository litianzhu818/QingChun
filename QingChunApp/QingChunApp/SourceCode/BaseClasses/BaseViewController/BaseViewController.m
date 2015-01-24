//
//  SuperViewController.m
//  FindLocationDemo
//
//  Created by 李天柱 on 14-4-15.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//
#import "BaseViewController.h"

@interface BaseViewController ()

@end


@implementation BaseViewController


//init方法最终还是要执行initWithNibName:bundle:方法，所以公共代码只需在该方法里添加即可
//Stortyboard中初始化不执行init和initWithNibName:bundle:方法，所以初始化全放viewDidLoad中
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _netWorkStatusNotice = [NotificationView sharedInstance];
    _netWorkStatusNotice.delegate = self;
    
    _defaultImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:_defaultImageView atIndex:0];
    [_defaultImageView setUserInteractionEnabled:YES];
    
    //自动布局约束
    [_defaultImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *tmpConstraints = [NSMutableArray array];
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_defaultImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_defaultImageView)]];
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_defaultImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_defaultImageView)]];
    [self.view addConstraints:tmpConstraints];
    
    [_defaultImageView setImage:[UIImage imageNamed:@"background"]];
    
#if !__has_feature(objc_arc)
    
#endif

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

/*********************************Private方法********************************************/

/**
 *  断网
 */
-(void)disconnectWithNet
{
    //提示断网
    [self performSelector:@selector(showNetworkSratusNotification) withObject:nil afterDelay:0.1];
}
/**
 *  再次连接网络
 */
-(void)connectWithNetAgain
{
    //重新连接代码
    [_netWorkStatusNotice dissmissNotificationView];
    [StatusBar dismiss];
}

-(void)showNetworkSratusNotification
{
    [_netWorkStatusNotice showViewWithText:@"notice" detail:@"There is no internet connection" image:PNG_NAME(@"no_internet.png")];
}

#pragma mark MPNotificationViewDelegate Methods
- (void)deleteNotificationView
{
    if ([[NetStatusManager sharedInstance] getNowNetWorkStatus] == NotReachable) {
        [StatusBar showWithStatus:@"no internet…"];
    }
}

/*******************************Public方法***********************************************/


- (void)dealloc
{
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
    
}

/**
 *  弹出提示对话框
 *
 *  @param message 对话框显示的类容
 */
-(void)showMessage:(NSString *)message
             title:(NSString *)title
 cancelButtonTitle:(NSString *)cancelTitle
       cancleBlock:(void (^)(void))cancleBlock
  otherButtonTitle:(NSString *)otherButtonTitle
        otherBlock:(void (^)(void))otherBlock
{
    UICustomAlertView *alertView = [[UICustomAlertView alloc] initWithTitle:title
                                                                    message:message
                                                          cancelButtonTitle:cancelTitle
                                                                cancleBlock:cancleBlock
                                                           otherButtonTitle:otherButtonTitle
                                                                 otherBlock:otherBlock];
    [alertView show];
}

-(void)showMessage:(NSString *)message
             title:(NSString *)title
 cancelButtonTitle:(NSString *)cancelTitle
       cancleBlock:(void (^)(void))cancleBlock
{
    UICustomAlertView *alertView = [[UICustomAlertView alloc] initWithTitle:title
                                                                    message:message
                                                          cancelButtonTitle:cancelTitle
                                                                cancleBlock:cancleBlock];
    [alertView show];
}


@end
