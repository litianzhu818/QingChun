//
//  RegisterViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 15/1/24.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterHelper.h"
#import "MBProgressHUD.h"
#import "UserInfoModel.h"

@interface RegisterViewController ()
{
    BOOL _isRead;
}

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *userNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *userPwdTextField;
@property (nonatomic, strong) IBOutlet UITextField *userPwdConfirmTextField;
@property (nonatomic, strong) IBOutlet UIButton    *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializationParameters];
}

- (void)didReceiveMemoryWarning {
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
    
    //self.defaultImageView.image = [UIImage imageNamed:@"register_bg"];
    self.navigationItem.title = LTZLocalizedString(@"register_title");
    
    self.registerButton.tag = 100;
    
    [self.registerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)initializationData
{
    //Here initialization your data parameters
    _isRead = YES;
}

- (BOOL)checkData
{
    if (!_isRead) {
        [self alertTitle:LTZLocalizedString(@"alert_title") message:LTZLocalizedString(@"notice_accepet_service_agreement") delegate:nil cancelBtn:LTZLocalizedString(@"alert_custom_btn_title") otherBtnName:nil];
        return NO;
    }
    
    if (![self isValidateEmail:self.emailTextField.text]) {
        [self alertTitle:LTZLocalizedString(@"alert_title") message:LTZLocalizedString(@"notice_error_email_formal") delegate:nil cancelBtn:LTZLocalizedString(@"alert_custom_btn_title") otherBtnName:nil];
        return NO;
    }
    if (![self isValidateUserName:self.userNameTextField.text]) {
        [self alertTitle:LTZLocalizedString(@"alert_title") message:LTZLocalizedString(@"notice_error_no_nickname") delegate:nil cancelBtn:LTZLocalizedString(@"alert_custom_btn_title") otherBtnName:nil];
        return NO;
    }
    
    if (![self isValidatePassword:self.userPwdTextField.text] ||
        ![self.userPwdTextField.text isEqualToString:self.userPwdConfirmTextField.text]) {
        [self alertTitle:LTZLocalizedString(@"alert_title") message:LTZLocalizedString(@"notice_error_pwd_not_same") delegate:nil cancelBtn:LTZLocalizedString(@"alert_custom_btn_title")otherBtnName:nil];
        return NO;
    }
    
    return YES;
}

- (void)registerAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RegisterHelper sharedHelper] registerWithUseKey:[[UserConfig sharedInstance] GetUserKey]
                                             userName:_userNameTextField.text
                                             password:_userPwdTextField.text
                                                email:_emailTextField.text
                                                  img:[[UserConfig sharedInstance] GetUserTempOtherSDKImageUrl]
                                      completeHandler:^(id userInfo, NSError *error) {
                                          
                                          MAIN_GCD(^{
                                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          });
                                          
                                          if (error) {
                                              NSString *errorMessage = [NSString stringWithFormat:@"%@%@",LTZLocalizedString(@"notice_error_register_failture"),[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
                                              MAIN_GCD(^{
                                                  [self alertTitle:LTZLocalizedString(@"alert_title") message:errorMessage delegate:nil cancelBtn:LTZLocalizedString(@"alert_custom_btn_title") otherBtnName:nil];
                                              });

                                          }else{
                                              UserInfoModel *userInfo = [UserInfoModel userInfoModelWithDictionary:[userInfo valueForKeyPath:@"data"]];
                                              [self registerSuccessWithUserInfo:userInfo];
                                          }
                                      }];
}

- (void)registerSuccessWithUserInfo:(UserInfoModel *)userInfo
{
    //保存用户基本信息
    [[UserConfig sharedInstance] SetUserInfo:userInfo];
    [[UserConfig sharedInstance] SetAlreadyLogin:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_login_success" object:userInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIButtonClicked Method
- (void)buttonClicked:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
        {
            //登录
            if ([self checkData]) {
                //开始登录
                [self registerAction];
            }
        }
            break;
        case 101:
        {
            //是否阅读协议
            if (_isRead) {
                
                [btn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
                _isRead = NO;
            }else{
                
                [btn setImage:[UIImage imageNamed:@"isRead_selectedButton@2x"] forState:UIControlStateNormal];
                
                _isRead = YES;
            }
        }
            break;
        case 102:
        {
            //服务协议
            [self alertTitle:LTZLocalizedString(@"alert_title") message:@"您点击了服务协议" delegate:nil cancelBtn:LTZLocalizedString(@"alert_cancel_btn_title") otherBtnName:nil];
        }
            break;
        case 103:
        {
            //隐私协议
            [self alertTitle:LTZLocalizedString(@"alert_title") message:@"您点击了隐私协议" delegate:nil cancelBtn:LTZLocalizedString(@"alert_cancel_btn_title") otherBtnName:nil];
        }
            break;
            
        default:
            break;
    }
    
}

//alertView
- (UIAlertView *)alertTitle:(NSString *)title
                    message:(NSString *)msg
                   delegate:(id)aDeleagte
                  cancelBtn:(NSString *)cancelName
               otherBtnName:(NSString *)otherbuttonName
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:aDeleagte cancelButtonTitle:cancelName otherButtonTitles:otherbuttonName, nil];
    [alert show];
    return alert;
}

//利用正则表达式验证邮箱的合法性
- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"^[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])+[A-Za-z\\d]{2,5}$";//[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//利用正则表达式验证用户名的合法性
- (BOOL)isValidateUserName:(NSString *)userName
{
    
    NSString *userRegex = @"^[\\p{Han}\\w-]{1,10}$";
    NSPredicate *userTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userRegex];
    return [userTest evaluateWithObject:userName];
}

//利用正则表达式验证密码的合法性
- (BOOL)isValidatePassword:(NSString *)password
{
    
    NSString *passwordRegex = @"^[\\p{Han}\\w-]{1,10}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:password];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return nil;
    }else if (section == 1){
        UIView *footerView = ({
            UIView *_footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
            _footerView.backgroundColor = [UIColor clearColor];
            _footerView;
        });
        
        UILabel *label = ({
            UILabel *_label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, 21.f)];
            _label.text = LTZLocalizedString(@"remark_nickname_formal");
            _label.font = [UIFont systemFontOfSize:10.f];
            _label.textColor = [UIColor blackColor];
            _label.backgroundColor = [UIColor clearColor];
            _label.textAlignment = NSTextAlignmentLeft;
            
            [footerView addSubview:_label];
            _label;
        });
        
        return footerView;
        
    }else if (section == 2){
        
        UIView *footerView = ({
            UIView *_footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
            _footerView.backgroundColor = [UIColor clearColor];
            _footerView;
        });
        
        UILabel *label = ({
            UILabel *_label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, 21.f)];
            _label.text = LTZLocalizedString(@"remark_pwd_formal");
            _label.font = [UIFont systemFontOfSize:10.f];
            _label.textColor = [UIColor blackColor];
            _label.backgroundColor = [UIColor clearColor];
            _label.textAlignment = NSTextAlignmentLeft;
            
            [footerView addSubview:_label];
            _label;
        });

        return footerView;
    }else if (section == 3){
        
        UIView *footerView = ({
            UIView *_footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 41.f)];
            _footerView.backgroundColor = [UIColor clearColor];
            _footerView;
        });
        UIButton *isReadBtn = ({
            UIButton *_isReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _isReadBtn.frame = CGRectMake(10.f, 10.f, 21.f, 21.f);
            [_isReadBtn setImage:[UIImage imageNamed:@"isRead_selectedButton@2x"] forState:UIControlStateNormal];
            [_isReadBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            _isReadBtn.tag = 101;
            [footerView addSubview:_isReadBtn];
            _isReadBtn;
        });
        
        UILabel *label1 = ({
            UILabel *_label = [[UILabel alloc] initWithFrame:CGRectMake(35.f, 10.f, 70.f, 21.f)];
            _label.text = LTZLocalizedString(@"remark_service_agreement1");
            _label.font = [UIFont systemFontOfSize:10.f];
            _label.textColor = [UIColor blackColor];
            _label.backgroundColor = [UIColor clearColor];
            _label.textAlignment = NSTextAlignmentLeft;
            
            [footerView addSubview:_label];
            _label;
        });
        
        UIButton *servicesBtn = ({
            UIButton *_servicesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _servicesBtn.frame = CGRectMake(110.f, 10.f, 40.f, 21.f);
            [_servicesBtn setTitle:LTZLocalizedString(@"remark_service_agreement2") forState:UIControlStateNormal];
            [_servicesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _servicesBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
            [_servicesBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [_servicesBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            _servicesBtn.tag = 102;
            [footerView addSubview:_servicesBtn];
            _servicesBtn;
        });
        
        UILabel *label2 = ({
            UILabel *_label = [[UILabel alloc] initWithFrame:CGRectMake(155.f, 10.f, 10.f, 21.f)];
            _label.text = LTZLocalizedString(@"remark_service_agreement3");
            _label.font = [UIFont systemFontOfSize:10.f];
            _label.textColor = [UIColor blackColor];
            _label.backgroundColor = [UIColor clearColor];
            _label.textAlignment = NSTextAlignmentLeft;
            
            [footerView addSubview:_label];
            _label;
        });
        
        UIButton *privacyBtn = ({
            UIButton *_privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _privacyBtn.frame = CGRectMake(170.f, 10.f, 40.f, 21.f);
            [_privacyBtn setTitle:LTZLocalizedString(@"remark_service_agreement4") forState:UIControlStateNormal];
            [_privacyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _privacyBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
            [_privacyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [_privacyBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            _privacyBtn.tag = 103;
            [footerView addSubview:_privacyBtn];
            _privacyBtn;
        });
        
        return footerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 5.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 5.f;
    }else if(section == 3){
        
        return 41.f;
        
    }else{
        return 21.f;
    }
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
