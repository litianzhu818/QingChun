//
//  CommentInputBar.m
//  QingChunApp
//
//  Created by Peter Lee on 15/3/31.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "CommentInputBar.h"
#import "HPGrowingTextView.h"

static const CGFloat barHeight = 44.0f;
static const CGFloat marginWidth = 8.0f;
static const CGFloat buttonWidth = 40.0f;
static const CGFloat buttonHeight = 36.0f;

@interface CommentInputBar () <HPGrowingTextViewDelegate>
{
    UIView __weak *_inView;
}
@end

@implementation CommentInputBar
@synthesize inView = _inView;

+ (CGFloat)barHeight
{
    return barHeight;
}

- (void)dealloc
{
    [self endListeningForKeyboard];
}

- (id)initWithPanGesture:(UIPanGestureRecognizer *)panGesture
                  inView:(UIView *)inView
                 bgImage:(UIImage *)bgImage
             placeHolder:(NSString *)placeHolder
              hasSendBtn:(BOOL)hasSendBtn
                btnTitle:(NSString *)btnTitle
          btnNormalImage:(UIImage *)btnNormalImage
     btnhighlightedImage:(UIImage *)btnhighlightedImage
               sendBlock:(void (^)(NSString *messgae))sendBlock
{
    CGRect currentFrame = inView.bounds;
    currentFrame.origin.y = currentFrame.size.height - barHeight;
    currentFrame.size.height = barHeight;
    
    self = [super initWithFrame:currentFrame];
    
    if (self) {
        _inView = inView;
        self.bgImage = bgImage;
        self.placeHolder = placeHolder;
        self.hasSendBtn = hasSendBtn;
        self.btnTitle = btnTitle;
        self.btnNormalImage = btnNormalImage;
        self.btnhighlightedImage = btnhighlightedImage;
        [self setPanGestureRecognizer:panGesture];
        [self setSendBlock:sendBlock];
        
        [self setup];
        
        [self beginListeningForKeyboard];
    }
    
    return self;
}

- (void)setup
{
    self.image = self.bgImage;
    self.userInteractionEnabled = YES;
    
    if (self.hasSendBtn) {
        _sendButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(self.frame.size.width - marginWidth - buttonWidth, (self.frame.size.height - buttonHeight)/2, buttonWidth, buttonHeight);
            
            button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            
            if (self.btnNormalImage) [button setBackgroundImage:self.btnNormalImage forState:UIControlStateNormal];
            if (self.btnhighlightedImage) [button setBackgroundImage:self.btnhighlightedImage forState:UIControlStateHighlighted];
            if (self.btnTitle) {
                [button setTitle:self.btnTitle forState:UIControlStateNormal];
                [button setTitle:self.btnTitle forState:UIControlStateHighlighted];
            }
            
            [button addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            button;
        });
    }
    
    _inputTextView = ({
        HPGrowingTextView *textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(marginWidth, marginWidth, (self.hasSendBtn ? (self.frame.size.width-3*marginWidth-buttonWidth):(self.frame.size.width-2*marginWidth)), self.frame.size.height-2*marginWidth)];
        textView.isScrollable = NO;
        textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        textView.minNumberOfLines = 1;
        textView.maxNumberOfLines = 4;
        // you can also set the maximum height in points with maxHeight
        // textView.maxHeight = 200.0f;
        textView.returnKeyType = UIReturnKeySend; //just as an example
        textView.font = [UIFont systemFontOfSize:16.0f];
        textView.delegate = self;
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.backgroundColor = [UIColor clearColor];
        textView.placeholder = self.placeHolder ? :@"说点什么吧...";
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // textView.text = @"test\n\ntest";
        // textView.animateHeightChange = NO; //turns off animation
        
        CGFloat cornerRadius = 6.0f;
        textView.backgroundColor = [UIColor whiteColor];
        textView.layer.borderWidth = 0.5f;
        textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        textView.layer.cornerRadius = cornerRadius;
        
        CGPoint center = textView.center;
        center.y = self.sendButton.center.y;
        textView.center = center;
        
        [self addSubview:textView];
        textView;
    });
}

- (void)setPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    _panGestureRecognizer = panGestureRecognizer;
    [_panGestureRecognizer addTarget:self action:@selector(resignFirstResponder)];
}

- (void)resignFirstResponder
{
    [self.inputTextView resignFirstResponder];
}

- (void)sendMessage:(id)sender
{
    NSString * content = self.inputTextView.text;
    if (content.length == 0 || [content isEqualToString:@""]){
        
        NSLog(@"请输入内容");
        
    }else {
        
        if (self.sendBlock) {
            self.sendBlock(content);
        }
        
        self.inputTextView.text = @"";
    }
}

- (void)beginListeningForKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)endListeningForKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}
-(void)inputKeyboardWillHide:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // The keyboard animation time duration
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // The keyboard animation curve
    NSUInteger animationCurve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    // begin animation action
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIView *view = window.rootViewController.view;
        
        CGFloat keyboardY = [view convertRect:keyboardRect fromView:nil].origin.y;
        
        CGRect inputViewFrame = self.frame;
        
        CGFloat inputViewFrameY = keyboardY - self.frame.size.height;
        
        // for ipad modal form presentations
        CGFloat messageViewFrameBottom = view.frame.size.height - self.frame.size.height;
        
        if(inputViewFrameY > messageViewFrameBottom) inputViewFrameY = messageViewFrameBottom;
        
        inputViewFrame.origin.y = inputViewFrameY;
        
        self.frame = inputViewFrame;
        
    }
    
    // end animation action
    [UIView commitAnimations];
}
#pragma mark - HPGrowingTextViewDelegate
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    return YES;
}
- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView
{
    return YES;
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float changedHeight = (growingTextView.frame.size.height - height);
    
    //changed its height of frame
    CGRect newFrame = self.frame;
    newFrame.size.height -= changedHeight;
    newFrame.origin.y += changedHeight;
    self.frame = newFrame;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        NSString * content = growingTextView.text;
        if (content.length == 0 || [content isEqualToString:@""]){
            NSLog(@"请输入内容");
        }
        else {
            
            if (self.sendBlock) {
                self.sendBlock(content);
            }
            
            growingTextView.text = @"";
        }
        return NO;
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
