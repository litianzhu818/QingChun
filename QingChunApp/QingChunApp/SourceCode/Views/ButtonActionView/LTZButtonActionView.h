//
//  LTZButtonActionView.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/5.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTZButtonActionView : UIScrollView

@property (strong, nonatomic) UIColor *displayTextColor;
@property (strong, nonatomic) UIFont *displayTextFont;
@property (strong, nonatomic) NSString *displayText;

+ (id)actionViewWithFrame:(CGRect)frame;
+ (id)actionViewWithFrame:(CGRect)frame displayText:(NSString *)displayText;
+ (id)actionViewWithFrame:(CGRect)frame displayText:(NSString *)displayText displayTextColor:(UIColor *)displayTextColor displayTextFont:(UIFont *)displayTextFont;

- (id)initWithFrame:(CGRect)frame displayText:(NSString *)displayText;
- (id)initWithFrame:(CGRect)frame displayText:(NSString *)displayText displayTextColor:(UIColor *)displayTextColor displayTextFont:(UIFont *)displayTextFont;

- (void)display;
//显示的位置
- (void)actionViewDisplayInPoint:(CGPoint)point withMessage:(NSString *)messageToDisplay;

@end
