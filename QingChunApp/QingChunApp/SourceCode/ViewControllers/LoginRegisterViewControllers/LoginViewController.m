//
//  LoginViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 14/11/7.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "LoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

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
    [_weiboButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_weiboButton setBackgroundImage:[UIImage imageNamed:@"weibo_se"] forState:UIControlStateSelected];
    
    [_QQButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_QQButton setBackgroundImage:[UIImage imageNamed:@"QQ_se"] forState:UIControlStateSelected];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login_se"] forState:UIControlStateSelected];
    [_backPwdButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//    [_nameTextField setDelegate:self];
//    [_pwdTextField setDelegate:self];
    
    [self.scrollView contentSizeToFit];
}

-(void)initializationData
{
    //Here initialization your data parameters
}

- (IBAction)ClikedWeiBoButton:(id)sender
{}
- (IBAction)ClikedOnQQButton:(id)sender
{}
- (IBAction)ClikedOnLoginButton:(id)sender
{}
- (IBAction)ClikedOnBackPwdButton:(id)sender
{}
- (IBAction)ClikedOnRegisterButton:(id)sender
{}
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
