//
//  LoginViewController.h
//  QingChunApp
//
//  Created by  李天柱 on 14/11/7.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIButton *QQButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *backPwdButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)ClikedWeiBoButton:(id)sender;
- (IBAction)ClikedOnQQButton:(id)sender;
- (IBAction)ClikedOnLoginButton:(id)sender;
- (IBAction)ClikedOnBackPwdButton:(id)sender;
- (IBAction)ClikedOnRegisterButton:(id)sender;

@end
