//
//  ProgreassHUD.m
//  KISSNAPP
//
//  Created by Peter Lee on 14/6/18.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#if !__has_feature(objc_arc)
#error ProgressHUD is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "ProgressHUD.h"

NSString * const ProgressHUDDidReceiveTouchEventNotification = @"ProgressHUDDidReceiveTouchEventNotification";
NSString * const ProgressHUDWillDisappearNotification = @"ProgressHUDWillDisappearNotification";
NSString * const ProgressHUDDidDisappearNotification = @"ProgressHUDDidDisappearNotification";
NSString * const ProgressHUDWillAppearNotification = @"ProgressHUDWillAppearNotification";
NSString * const ProgressHUDDidAppearNotification = @"ProgressHUDDidAppearNotification";

NSString * const ProgressHUDStatusUserInfoKey = @"ProgressHUDStatusUserInfoKey";

static UIColor *ProgressHUDBackgroundColor;
static UIColor *ProgressHUDForegroundColor;
static CGFloat ProgressHUDRingThickness;
static UIFont  *ProgressHUDFont;
static UIImage *ProgressHUDSuccessImage;
static UIImage *ProgressHUDErrorImage;

static const CGFloat ProgressHUDRingRadius = 18;
static const CGFloat ProgressHUDRingNoTextRadius = 24;
static const CGFloat ProgressHUDParallaxDepthPoints = 10;

@interface ProgressHUD ()

@property (nonatomic, readwrite) ProgressHUDMaskType maskType;
@property (nonatomic, strong, readonly) NSTimer *fadeOutTimer;
@property (nonatomic, readonly, getter = isClear) BOOL clear;

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) UILabel *stringLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CAShapeLayer *indefiniteAnimatedLayer;

@property (nonatomic, readwrite) CGFloat progress;
@property (nonatomic, readwrite) NSUInteger activityCount;
@property (nonatomic, strong) CAShapeLayer *backgroundRingLayer;
@property (nonatomic, strong) CAShapeLayer *ringLayer;

@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;
@property (nonatomic, assign) UIOffset offsetFromCenter;


- (void)showProgress:(float)progress
              status:(NSString*)string
            maskType:(ProgressHUDMaskType)hudMaskType;

- (void)showImage:(UIImage*)image
           status:(NSString*)status
         duration:(NSTimeInterval)duration;

- (void)dismiss;

- (void)setStatus:(NSString*)string;
- (void)registerNotifications;
- (NSDictionary *)notificationUserInfo;
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle;
- (void)positionHUD:(NSNotification*)notification;
- (NSTimeInterval)displayDurationForString:(NSString*)string;

@end


@implementation ProgressHUD

+ (ProgressHUD*)sharedInstance {
    static dispatch_once_t once;
    static ProgressHUD *sharedInstance;
    dispatch_once(&once, ^ {
        sharedInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedInstance;
}

#pragma mark - Setters

+ (void)setStatus:(NSString *)string {
	[[self sharedInstance] setStatus:string];
}

+ (void)setBackgroundColor:(UIColor *)color {
    [self sharedInstance].hudView.backgroundColor = color;
    ProgressHUDBackgroundColor = color;
}

+ (void)setForegroundColor:(UIColor *)color {
    [self sharedInstance];
    ProgressHUDForegroundColor = color;
}

+ (void)setFont:(UIFont *)font {
    [self sharedInstance];
    ProgressHUDFont = font;
}

+ (void)setRingThickness:(CGFloat)width {
    [self sharedInstance];
    ProgressHUDRingThickness = width;
}

+ (void)setSuccessImage:(UIImage *)image {
    [self sharedInstance];
    ProgressHUDSuccessImage = image;
}

+ (void)setErrorImage:(UIImage *)image {
    [self sharedInstance];
    ProgressHUDErrorImage = image;
}

#pragma mark - Show Methods

+ (void)show {
    [ProgressHUD dismiss];
    [[self sharedInstance] showProgress:-1 status:nil maskType:ProgressHUDMaskTypeNone];
}

+ (void)showWithStatus:(NSString *)status {
    [ProgressHUD dismiss];
    [[self sharedInstance] showProgress:-1 status:status maskType:ProgressHUDMaskTypeNone];
}

+ (void)showWithMaskType:(ProgressHUDMaskType)maskType {
    [ProgressHUD dismiss];
    [[self sharedInstance] showProgress:-1 status:nil maskType:maskType];
}

+ (void)showWithStatus:(NSString*)status maskType:(ProgressHUDMaskType)maskType {
    [ProgressHUD dismiss];
    [[self sharedInstance] showProgress:-1 status:status maskType:maskType];
}

+ (void)showProgress:(float)progress {
    [ProgressHUD dismiss];
    [[self sharedInstance] showProgress:progress status:nil maskType:ProgressHUDMaskTypeNone];
}

+ (void)showProgress:(float)progress status:(NSString *)status {
    [ProgressHUD dismiss];
    [[self sharedInstance] showProgress:progress status:status maskType:ProgressHUDMaskTypeNone];
}

+ (void)showProgress:(float)progress status:(NSString *)status maskType:(ProgressHUDMaskType)maskType {
    [ProgressHUD dismiss];
    [[self sharedInstance] showProgress:progress status:status maskType:maskType];
}

#pragma mark - Show then dismiss methods

+ (void)showSuccessWithStatus:(NSString *)string {
    //[self sharedInstance];
    [ProgressHUD dismiss];
    [self showImage:ProgressHUDSuccessImage status:string];
}

+ (void)showErrorWithStatus:(NSString *)string {
    //[self sharedInstance];
    [ProgressHUD dismiss];
    [self showImage:ProgressHUDErrorImage status:string];
}

+ (void)showImage:(UIImage *)image status:(NSString *)string {
    NSTimeInterval displayInterval = [[ProgressHUD sharedInstance] displayDurationForString:string];
    [[self sharedInstance] showImage:image status:string duration:displayInterval];
}


#pragma mark - Dismiss Methods

+ (void)popActivity {
    [self sharedInstance].activityCount--;
    if([self sharedInstance].activityCount == 0)
        [[self sharedInstance] dismiss];
}

+ (void)dismiss {
    if ([self iisible]) {
        [[self sharedInstance] dismiss];
    }
}


#pragma mark - Offset

+ (void)setOffsetFromCenter:(UIOffset)offset {
    [self sharedInstance].offsetFromCenter = offset;
}

+ (void)resetOffsetFromCenter {
    [self setOffsetFromCenter:UIOffsetZero];
}

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.activityCount = 0;
        
        ProgressHUDBackgroundColor = [UIColor whiteColor];
        ProgressHUDForegroundColor = [UIColor blackColor];
        ProgressHUDFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        ProgressHUDSuccessImage = [[UIImage imageNamed:@"ProgressHUD.bundle/success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        ProgressHUDErrorImage = [[UIImage imageNamed:@"ProgressHUD.bundle/error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        ProgressHUDRingThickness = 4;
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.maskType) {
            
        case ProgressHUDMaskTypeBlack: {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
            
        case ProgressHUDMaskTypeGradient: {
            
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGFloat freeHeight = self.bounds.size.height - self.visibleKeyboardHeight;
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, freeHeight/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }
    }
}

- (void)updatePosition {
	
    CGFloat hudWidth = 100;
    CGFloat hudHeight = 100;
    CGFloat stringHeightBuffer = 20;
    CGFloat stringAndImageHeightBuffer = 80;
    
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    
    NSString *string = self.stringLabel.text;
    // False if it's text-only
    BOOL imageUsed = (self.imageView.image) || (self.imageView.hidden);
    
    if(string) {
        CGSize constraintSize = CGSizeMake(200, 300);
        CGRect stringRect = [string boundingRectWithSize:constraintSize
                                                 options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                              attributes:@{NSFontAttributeName: self.stringLabel.font}
                                                 context:NULL];
        stringWidth = stringRect.size.width;
        stringHeight = ceil(stringRect.size.height);
        
        if (imageUsed)
            hudHeight = stringAndImageHeightBuffer + stringHeight;
        else
            hudHeight = stringHeightBuffer + stringHeight;
        
        if(stringWidth > hudWidth)
            hudWidth = ceil(stringWidth/2)*2;
        
        CGFloat labelRectY = imageUsed ? 68 : 9;
        
        if(hudHeight > 100) {
            labelRect = CGRectMake(12, labelRectY, hudWidth, stringHeight);
            hudWidth+=24;
        } else {
            hudWidth+=24;
            labelRect = CGRectMake(0, labelRectY, hudWidth, stringHeight);
        }
    }
	
	self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    if(string)
        self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, 36);
	else
       	self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, CGRectGetHeight(self.hudView.bounds)/2);
	
	self.stringLabel.hidden = NO;
	self.stringLabel.frame = labelRect;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	if(string) {
        CGPoint center = CGPointMake((CGRectGetWidth(self.hudView.bounds)/2), 36);
        self.indefiniteAnimatedLayer.position = center;
        
        if(self.progress != -1)
            self.backgroundRingLayer.position = self.ringLayer.position = CGPointMake((CGRectGetWidth(self.hudView.bounds)/2), 36);
	}
    else {
        CGPoint center = CGPointMake((CGRectGetWidth(self.hudView.bounds)/2), CGRectGetHeight(self.hudView.bounds)/2);
        self.indefiniteAnimatedLayer.position = center;
        
        if(self.progress != -1)
            self.backgroundRingLayer.position = self.ringLayer.position = CGPointMake((CGRectGetWidth(self.hudView.bounds)/2), CGRectGetHeight(self.hudView.bounds)/2);
    }
    
    [CATransaction commit];
}

- (void)setStatus:(NSString *)string {
    
	self.stringLabel.text = string;
    [self updatePosition];
    
}

- (void)setFadeOutTimer:(NSTimer *)newTimer {
    
    if(_fadeOutTimer)
        [_fadeOutTimer invalidate], _fadeOutTimer = nil;
    
    if(newTimer)
        _fadeOutTimer = newTimer;
}


- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}


- (NSDictionary *)notificationUserInfo
{
    return (self.stringLabel.text ? @{ProgressHUDStatusUserInfoKey : self.stringLabel.text} : nil);
}


- (void)positionHUD:(NSNotification*)notification {
    
    CGFloat keyboardHeight;
    double animationDuration;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(UIInterfaceOrientationIsPortrait(orientation))
                keyboardHeight = keyboardFrame.size.height;
            else
                keyboardHeight = keyboardFrame.size.width;
        } else
            keyboardHeight = 0;
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    if(keyboardHeight > 0)
        activeHeight += statusBarFrame.size.height*2;
    
    activeHeight -= keyboardHeight;
    CGFloat posY = floor(activeHeight*0.45);
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    }
    
    if(notification) {
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    }
    
    else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
    
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.hudView.transform = CGAffineTransformMakeRotation(angle);
    self.hudView.center = CGPointMake(newCenter.x + self.offsetFromCenter.horizontal, newCenter.y + self.offsetFromCenter.vertical);
}

- (void)overlayViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:ProgressHUDDidReceiveTouchEventNotification object:event];
}

#pragma mark - Master show/dismiss methods

- (void)showProgress:(float)progress status:(NSString*)string maskType:(ProgressHUDMaskType)hudMaskType {
    
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
    }
    
    if(!self.superview)
        [self.overlayView addSubview:self];
    
    self.fadeOutTimer = nil;
    self.imageView.hidden = YES;
    self.maskType = hudMaskType;
    self.progress = progress;
    
    self.stringLabel.text = string;
    [self updatePosition];
    
    if(progress >= 0) {
        self.imageView.image = nil;
        self.imageView.hidden = NO;
        [self.indefiniteAnimatedLayer removeFromSuperlayer];
        
        self.ringLayer.strokeEnd = progress;
        
        if(progress == 0)
            self.activityCount++;
    }
    else {
        self.activityCount++;
        [self cancelRingLayerAnimation];
        [self.hudView.layer addSublayer:self.indefiniteAnimatedLayer];
    }
    
    if(self.maskType != ProgressHUDMaskTypeNone) {
        self.overlayView.userInteractionEnabled = YES;
        self.accessibilityLabel = string;
        self.isAccessibilityElement = YES;
    }
    else {
        self.overlayView.userInteractionEnabled = NO;
        self.hudView.accessibilityLabel = string;
        self.hudView.isAccessibilityElement = YES;
    }
    
    [self.overlayView setHidden:NO];
    self.overlayView.backgroundColor = [UIColor clearColor];
    [self positionHUD:nil];
    
    if(self.alpha != 1) {
        NSDictionary *userInfo = [self notificationUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:ProgressHUDWillAppearNotification
                                                            object:nil
                                                          userInfo:userInfo];
        
        [self registerNotifications];
        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
        
        if(self.isClear) {
            self.alpha = 1;
            self.hudView.alpha = 0;
        }
        /*************************************背景层*********************************************/
//        UIViewController *topVC = [self appRootViewController];
//        UIView *bgImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
//        bgImageView.backgroundColor = [UIColor blackColor];
//        bgImageView.alpha = 0.6f;
//        bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        [topVC.view addSubview:bgImageView];

        /*************************************背景层*********************************************/
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3, 1/1.3);
                             
                             if(self.isClear) // handle iOS 7 UIToolbar not answer well to hierarchy opacity change
                                 self.hudView.alpha = 1;
                             else
                                 self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             [[NSNotificationCenter defaultCenter] postNotificationName:ProgressHUDDidAppearNotification
                                                                                 object:nil
                                                                               userInfo:userInfo];
                             UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                             UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, string);
                         }];
        
        [self setNeedsDisplay];
    }
}

//获取当前界面的COntroller类
- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)showImage:(UIImage *)image status:(NSString *)string duration:(NSTimeInterval)duration {
    self.progress = -1;
    [self cancelRingLayerAnimation];
    
    if(![self.class iisible])
        [self.class show];
    
    self.imageView.tintColor = ProgressHUDForegroundColor;
    self.imageView.image = image;
    self.imageView.hidden = NO;
    
    self.stringLabel.text = string;
    [self updatePosition];
    [self.indefiniteAnimatedLayer removeFromSuperlayer];
    
    if(self.maskType != ProgressHUDMaskTypeNone) {
        self.accessibilityLabel = string;
        self.isAccessibilityElement = YES;
    } else {
        self.hudView.accessibilityLabel = string;
        self.hudView.isAccessibilityElement = YES;
    }
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, string);
    
    self.fadeOutTimer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
}

- (void)dismiss {
    NSDictionary *userInfo = [self notificationUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:ProgressHUDWillDisappearNotification
                                                        object:nil
                                                      userInfo:userInfo];
    
    self.activityCount = 0;
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
                         if(self.isClear) // handle iOS 7 UIToolbar not answer well to hierarchy opacity change
                             self.hudView.alpha = 0;
                         else
                             self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         if(self.alpha == 0 || self.hudView.alpha == 0) {
                             self.alpha = 0;
                             self.hudView.alpha = 0;
                             
                             [[NSNotificationCenter defaultCenter] removeObserver:self];
                             [self cancelRingLayerAnimation];
                             [_hudView removeFromSuperview];
                             _hudView = nil;
                             
                             [_overlayView removeFromSuperview];
                             _overlayView = nil;
                             
                             [_indefiniteAnimatedLayer removeFromSuperlayer];
                             _indefiniteAnimatedLayer = nil;
                             
                             UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:ProgressHUDDidDisappearNotification
                                                                                 object:nil
                                                                               userInfo:userInfo];
                             
                             // Tell the rootViewController to update the StatusBar appearance
                             UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
                             if ([rootController respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                                 [rootController setNeedsStatusBarAppearanceUpdate];
                             }
                             // uncomment to make sure UIWindow is gone from app.windows
                             //NSLog(@"%@", [UIApplication sharedApplication].windows);
                             //NSLog(@"keyWindow = %@", [UIApplication sharedApplication].keyWindow);
                         }
                     }];
}


#pragma mark - Ring progress animation

- (CAShapeLayer*)indefiniteAnimatedLayer {
    if(!_indefiniteAnimatedLayer) {
        CGPoint center = CGPointMake(CGRectGetWidth(_hudView.frame)/2, CGRectGetHeight(_hudView.frame)/2);
        CGFloat radius = self.stringLabel.text ? ProgressHUDRingRadius : ProgressHUDRingNoTextRadius;
        CGPoint arcCenter = CGPointMake(radius+ProgressHUDRingThickness/2+5, radius+ProgressHUDRingThickness/2+5);
        CGRect rect = CGRectMake(center.x-radius, center.y-radius, arcCenter.x*2, arcCenter.y*2);
        
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                    radius:radius
                                                                startAngle:M_PI*3/2
                                                                  endAngle:M_PI/2+M_PI*5
                                                                 clockwise:YES];
        
        _indefiniteAnimatedLayer = [CAShapeLayer layer];
        _indefiniteAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
        _indefiniteAnimatedLayer.frame = rect;
        _indefiniteAnimatedLayer.fillColor = [UIColor clearColor].CGColor;
        _indefiniteAnimatedLayer.strokeColor = ProgressHUDForegroundColor.CGColor;
        _indefiniteAnimatedLayer.lineWidth = ProgressHUDRingThickness;
        _indefiniteAnimatedLayer.lineCap = kCALineCapRound;
        _indefiniteAnimatedLayer.lineJoin = kCALineJoinBevel;
        _indefiniteAnimatedLayer.path = smoothedPath.CGPath;
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[UIImage imageNamed:@"ProgressHUD.bundle/angle-mask@2x.png"] CGImage];
        maskLayer.frame = _indefiniteAnimatedLayer.bounds;
        _indefiniteAnimatedLayer.mask = maskLayer;
        
        NSTimeInterval animationDuration = 1;
        CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = 0;
        animation.toValue = [NSNumber numberWithFloat:M_PI*2];
        animation.duration = animationDuration;
        animation.timingFunction = linearCurve;
        animation.removedOnCompletion = NO;
        animation.repeatCount = INFINITY;
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = NO;
        [_indefiniteAnimatedLayer.mask addAnimation:animation forKey:@"rotate"];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = INFINITY;
        animationGroup.removedOnCompletion = NO;
        animationGroup.timingFunction = linearCurve;
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0.015;
        strokeStartAnimation.toValue = @0.515;
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0.485;
        strokeEndAnimation.toValue = @0.985;
        
        animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
        [_indefiniteAnimatedLayer addAnimation:animationGroup forKey:@"progress"];
        
    }
    return _indefiniteAnimatedLayer;
}

- (CAShapeLayer *)ringLayer {
    if(!_ringLayer) {
        CGPoint center = CGPointMake(CGRectGetWidth(_hudView.frame)/2, CGRectGetHeight(_hudView.frame)/2);
        _ringLayer = [self createRingLayerWithCenter:center
                                              radius:ProgressHUDRingRadius
                                           lineWidth:ProgressHUDRingThickness
                                               color:ProgressHUDForegroundColor];
        [self.hudView.layer addSublayer:_ringLayer];
    }
    return _ringLayer;
}

- (CAShapeLayer *)backgroundRingLayer {
    if(!_backgroundRingLayer) {
        CGPoint center = CGPointMake(CGRectGetWidth(_hudView.frame)/2, CGRectGetHeight(_hudView.frame)/2);
        _backgroundRingLayer = [self createRingLayerWithCenter:center
                                                        radius:ProgressHUDRingRadius
                                                     lineWidth:ProgressHUDRingThickness
                                                         color:[ProgressHUDForegroundColor colorWithAlphaComponent:0.1]];
        _backgroundRingLayer.strokeEnd = 1;
        [self.hudView.layer addSublayer:_backgroundRingLayer];
    }
    return _backgroundRingLayer;
}

- (void)cancelRingLayerAnimation {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_hudView.layer removeAllAnimations];
    
    _ringLayer.strokeEnd = 0.0f;
    if (_ringLayer.superlayer) {
        [_ringLayer removeFromSuperlayer];
    }
    _ringLayer = nil;
    
    if (_backgroundRingLayer.superlayer) {
        [_backgroundRingLayer removeFromSuperlayer];
    }
    _backgroundRingLayer = nil;
    
    [CATransaction commit];
}

- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    
    UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x-radius, center.y-radius, radius*2, radius*2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineCapRound;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}

#pragma mark - Utilities

+ (BOOL)iisible {
    return ([self sharedInstance].alpha == 1);
}


#pragma mark - Getters

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    return MIN((float)string.length*0.06 + 0.3, 5.0);
}

- (BOOL)isClear { // used for iOS 7
    return (self.maskType == ProgressHUDMaskTypeClear || self.maskType == ProgressHUDMaskTypeNone);
}

- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}

- (UIView *)hudView {
    if(!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.backgroundColor = ProgressHUDBackgroundColor;
        _hudView.layer.cornerRadius = 14;
        _hudView.layer.masksToBounds = YES;
        
        _hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.x" type: UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        effectX.minimumRelativeValue = @(-ProgressHUDParallaxDepthPoints);
        effectX.maximumRelativeValue = @(ProgressHUDParallaxDepthPoints);
        
        UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.y" type: UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        effectY.minimumRelativeValue = @(-ProgressHUDParallaxDepthPoints);
        effectY.maximumRelativeValue = @(ProgressHUDParallaxDepthPoints);
        
        [_hudView addMotionEffect: effectX];
        [_hudView addMotionEffect: effectY];
        
        [self addSubview:_hudView];
    }
    return _hudView;
}

- (UILabel *)stringLabel {
    if (_stringLabel == nil) {
        _stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_stringLabel.backgroundColor = [UIColor clearColor];
		_stringLabel.adjustsFontSizeToFitWidth = YES;
        _stringLabel.textAlignment = NSTextAlignmentCenter;
		_stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_stringLabel.textColor = ProgressHUDForegroundColor;
		_stringLabel.font = ProgressHUDFont;
        _stringLabel.numberOfLines = 0;
    }
    
    if(!_stringLabel.superview)
        [self.hudView addSubview:_stringLabel];
    
    return _stringLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil)
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    
    if(!_imageView.superview)
        [self.hudView addSubview:_imageView];
    
    return _imageView;
}


- (CGFloat)visibleKeyboardHeight {
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")])
            return possibleKeyboard.bounds.size.height;
    }
    
    return 0;
}

@end
