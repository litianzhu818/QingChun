//
//  ProgressHUD.h
//  KISSNAPP
//
//  Created by Peter Lee on 14/6/18.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//
//  更新记录：201406191240 内容：在show到showErrorWithStatus中加入了[ProgressHUD dismiss];
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AvailabilityMacros.h>

extern NSString * const ProgressHUDDidReceiveTouchEventNotification;
extern NSString * const ProgressHUDWillDisappearNotification;
extern NSString * const ProgressHUDDidDisappearNotification;
extern NSString * const ProgressHUDWillAppearNotification;
extern NSString * const ProgressHUDDidAppearNotification;

extern NSString * const ProgressHUDStatusUserInfoKey;

enum {
    ProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    ProgressHUDMaskTypeClear, // don't allow
    ProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    ProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

typedef NSUInteger ProgressHUDMaskType;

@interface ProgressHUD : UIView

#pragma mark - Customization

+ (void)setBackgroundColor:(UIColor*)color; // default is [UIColor whiteColor]
+ (void)setForegroundColor:(UIColor*)color; // default is [UIColor blackColor]
+ (void)setRingThickness:(CGFloat)width;    // default is 4 pt
+ (void)setFont:(UIFont*)font;              // default is [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
+ (void)setSuccessImage:(UIImage*)image;    // default is bundled success image from Glyphish
+ (void)setErrorImage:(UIImage*)image;      // default is bundled error image from Glyphish

#pragma mark - Show Methods

+ (void)show;
+ (void)showWithMaskType:(ProgressHUDMaskType)maskType;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(ProgressHUDMaskType)maskType;

+ (void)showProgress:(float)progress;
+ (void)showProgress:(float)progress status:(NSString*)status;
+ (void)showProgress:(float)progress status:(NSString*)status maskType:(ProgressHUDMaskType)maskType;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing

// stops the activity indicator, shows a glyph + status, and dismisses HUD 1s later
+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showImage:(UIImage*)image status:(NSString*)status; // use 28x28 white pngs

+ (void)setOffsetFromCenter:(UIOffset)offset;
+ (void)resetOffsetFromCenter;

+ (void)popActivity;
+ (void)dismiss;

+ (BOOL)iisible;

@end
