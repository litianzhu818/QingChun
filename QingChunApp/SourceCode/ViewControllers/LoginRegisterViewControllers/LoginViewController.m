//
//  LoginViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 14/11/7.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    UITapGestureRecognizer *tapGestureRecognizer;
    UITextField *activeField;
}
@end

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
    [self initTapGester];
    [self addNotifications];
}
-(void) viewDidAppear:(BOOL)animated
{
    
    self.scrollView.frame = CGRectMake(0, 0, VIEW_W(self.view), VIEW_H(self.view));
    
    [self.scrollView setContentSize:CGSizeMake(VIEW_W(self.view), 1.3 * VIEW_H(self.view))];
    [self.scrollView setContentInset:UIEdgeInsetsZero];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self removeTapGester];
    [self removeNotifications];
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
    [_weiboButton setBackgroundImage:[UIImage imageNamed:@"weibo_se"] forState:UIControlStateHighlighted];
    
    [_QQButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_QQButton setBackgroundImage:[UIImage imageNamed:@"QQ_se"] forState:UIControlStateHighlighted];
    [_nameTextField setDelegate:self];
    [_pwdTextField setDelegate:self];
}

-(void)initializationData
{
    //Here initialization your data parameters
}

- (void)initTapGester
{
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeybord:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)removeTapGester
{
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

-(void)addNotifications
{
    [NotificationCenter addObserver:self
                           selector:@selector(keyboardWillShow:)
                               name:UIKeyboardWillShowNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(keyboardWillHide:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
}

-(void)removeNotifications
{
    [NotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the duration of the animation.
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"这里是：%@", NSStringFromCGSize(keyboardSize));
    //调整scrollView的内含视图的size
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    [UIView commitAnimations];
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect activeRect = self.view.frame;
    activeRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(activeRect, activeField.frame.origin)) {
//        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-keyboardSize.height);
//        [_scrollView setContentOffset:scrollPoint animated:YES];
        [_scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    //让scrollView恢复愿来的状态
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    [UIView commitAnimations];
}


- (void)hideKeybord:(id)sender
{
    [_nameTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
}
#pragma mark -
#pragma mark - UITextFiledDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    [textField resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
