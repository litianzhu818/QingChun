//
//  LoginViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 14/11/7.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "LoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "LoginHelper.h"
#import "LTZLocationManager.h"
#import "HttpSessionManager.h"
#import "MBProgressHUD.h"

@implementation LoginViewController

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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{

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
    
    self.defaultImageView.image = [UIImage imageNamed:@"login_bg"];
    self.navigationItem.title = LTZLocalizedString(@"login_title");
    UIButton *cancelButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:LTZLocalizedString(@"login_bar_button_title") forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 60, 40);
        btn;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    [_weiboButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_weiboButton setBackgroundImage:[UIImage imageNamed:@"weibo_se"] forState:UIControlStateSelected];
    
    [_QQButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_QQButton setBackgroundImage:[UIImage imageNamed:@"QQ_se"] forState:UIControlStateSelected];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login_se"] forState:UIControlStateSelected];
    [_backPwdButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [self.scrollView contentSizeToFit];
}

-(void)initializationData
{
    //Here initialization your data parameters
}

- (void)cancelLogin
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)ClikedWeiBoButton:(id)sender
{
    [self loginWithOtherSDK:LoginTypeWeibo];
}
- (IBAction)ClikedOnQQButton:(id)sender
{
    [self loginWithOtherSDK:LoginTypeTencent];
}
- (IBAction)ClikedOnLoginButton:(id)sender
{
    
}
- (IBAction)ClikedOnBackPwdButton:(id)sender
{
    
}
- (IBAction)ClikedOnRegisterButton:(id)sender
{
    
}
- (BOOL)checkData
{
    if (!self.nameTextField.text || [self.nameTextField.text isEqualToString:@""]) {
        return NO;
    }
    
    if (!self.pwdTextField.text || [self.pwdTextField.text isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (void)loginWithOtherSDK:(LoginType)loginType
{
    //添加UI
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LoginHelper sharedInstance] authorizeWithLoginType:loginType
                                         completeHandler:^(LoginType loginType, id userInfo, NSError *error) {
                                             
                                             if (!error) {//QQ获取到信息
                                                 
                                                 [self locationWithUserInfo:userInfo loginType:loginType];
                                                 
                                             }else{//第三方登录不成功
                                                 
                                                 MAIN_GCD(^{
                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                     [self showMessage:@"登录失败！" title:@"提示" cancelButtonTitle:@"知道了" cancleBlock:^{
                                                         
                                                     }];
                                                 });
                                                 
                                             }
                                            
                                         }];
    /*
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // 定时执行
    
     });
     */
}

- (void)locationWithUserInfo:(id)userInfo loginType:(LoginType)loginType
{
    MAIN_GCD((^{
        
        //开始获取定位信息
        [LTZLocationManager locationWithBlock:^(NSString *state, NSString *city, NSString *address, CLLocationCoordinate2D locationCorrrdinate, NSError *error) {
            
            if (!error) {
                [userInfo setObject:[NSString stringWithFormat:@"%lf",locationCorrrdinate.longitude] forKey:@"longitude"];
                [userInfo setObject:[NSString stringWithFormat:@"%lf",locationCorrrdinate.latitude] forKey:@"latitude"];
                [userInfo setObject:[NSString stringWithFormat:@"%@,%@",state,city] forKey:@"address"];
                
                [self loginWithUserInfo:userInfo loginType:loginType];
                
            }else{//定位不成功
                
                MAIN_GCD(^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self showMessage:@"定位失败！" title:@"提示" cancelButtonTitle:@"知道了" cancleBlock:^{
                        
                    }];

                });
                
            }
            
        }];
        
    }));
}

- (void)loginWithUserInfo:(id)userInfo loginType:(LoginType)loginType
{
    //调用登录方法
    [[HttpSessionManager sharedInstance] loginWithIdentifier:[NSString stringWithFormat:@"%d",loginType]
                                                      params:userInfo
                                                       block:^(id data, NSError *error) {
                                                           
                                                           if (!error) {//登录成功
                                                               NSDictionary *userInfoDic = [data objectForKey:@"data"];
                                                               [[UserConfig sharedInstance] SetUserKey:[userInfo objectForKey:@"userKey"]];
                                                               //这里是用户的基本信息，登录成功跳转界面
                                                               //code...
                                                               
                                                           }else{//登录失败
                                                              LOG(@"Error:%@",[error.userInfo objectForKey:@"msg"]);
                                                               if (error.code == 2001) {//未绑定邮箱，需绑定邮箱
                                                                   NSString *userKey = [[error.userInfo objectForKey:@"data"] objectForKey:@"userKey"];
                                                                   [[UserConfig sharedInstance] SetUserKey:userKey];
                                                                   //跳转到绑定邮箱界面
                                                                   //code...
                                                                   
                                                               }
                                                           }
                                                           
                                                           MAIN_GCD(^{
                                                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                               [self showMessage:@"登录失败！" title:@"提示" cancelButtonTitle:@"知道了" cancleBlock:^{
                                                                   
                                                               }];
                                                           });
                                                       }];
}

#pragma mark - UITextFiledDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_nameTextField]) {
        [_pwdTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
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
