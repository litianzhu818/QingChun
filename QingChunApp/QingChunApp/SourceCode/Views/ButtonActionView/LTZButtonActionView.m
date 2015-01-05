//
//  LTZButtonActionView.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/5.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LTZButtonActionView.h"

@interface LTZButtonActionView ()<UIScrollViewDelegate>
{
    UILabel *_displayLabel;
}

@end

@implementation LTZButtonActionView

+ (id)actionViewWithFrame:(CGRect)frame
{
    return [LTZButtonActionView actionViewWithFrame:frame];
}

+ (id)actionViewWithFrame:(CGRect)frame displayText:(NSString *)displayText
{
    return [LTZButtonActionView actionViewWithFrame:frame displayText:displayText displayTextColor:nil displayTextFont:nil];
}

+ (id)actionViewWithFrame:(CGRect)frame displayText:(NSString *)displayText displayTextColor:(UIColor *)displayTextColor displayTextFont:(UIFont *)displayTextFont
{
    return [[self alloc] initWithFrame:frame displayText:displayText displayTextColor:displayTextColor displayTextFont:displayTextFont];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame displayText:nil];
}

- (id)initWithFrame:(CGRect)frame displayText:(NSString *)displayText
{
    return [self initWithFrame:frame displayText:displayText displayTextColor:nil displayTextFont:nil];
}

- (id)initWithFrame:(CGRect)frame displayText:(NSString *)displayText displayTextColor:(UIColor *)displayTextColor displayTextFont:(UIFont *)displayTextFont
{
    if (self) {
        // Initialization code
        self.delegate = self;
        self.maximumZoomScale = 3.0;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setHidden:YES];
        
        [self setDisplayText:displayText];
        [self setDisplayTextColor:displayTextColor];
        [self setDisplayTextFont:displayTextFont];
        [self initDisplayLabel];
    }
    return self;
}

#pragma mark - Public method

- (void)display
{
    [self actionViewDisplayInPoint:self.frame.origin withMessage:self.displayText];
}

- (void)actionViewDisplayInPoint:(CGPoint)point withMessage:(NSString *)messageToDisplay
{
    [self setDisplayText:messageToDisplay];
    [_displayLabel setText:self.displayText];
    
    [self setFrame:CGRectMake(point.x, point.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    [self setHidden:NO];
    
    [self setZoomScale:3.0 animated:YES];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        [_displayLabel setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        
        [self resetView];
        
    }];
}

#pragma mark - Private method

- (void)initDisplayLabel
{
    _displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _displayLabel.text = self.displayText ?:@"+1";//The default value
    _displayLabel.textColor = self.displayTextColor ? :[UIColor redColor];
    _displayLabel.backgroundColor = [UIColor clearColor];
    _displayLabel.textAlignment = NSTextAlignmentCenter;
    _displayLabel.font = self.displayTextFont ? :[UIFont boldSystemFontOfSize:12];
    [self addSubview:_displayLabel];
}

- (void)resetView
{
    [self           setHidden:YES];
    [self           setZoomScale:1.0];
    [_displayLabel  setAlpha:1.0];
}

- (void)setDisplayTextFont:(UIFont *)displayTextFont
{
    _displayTextFont = displayTextFont;
    _displayLabel.font = self.displayTextFont;
}

- (void)setDisplayTextColor:(UIColor *)displayTextColor
{
    _displayTextColor = displayTextColor;
    _displayLabel.textColor = self.displayTextColor;
}


#pragma mark - UIScrollView delegate method

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _displayLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
