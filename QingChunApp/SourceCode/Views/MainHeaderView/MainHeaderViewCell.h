//
//  MainHeaderViewCell.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHeaderViewItem.h"

@interface MainHeaderViewCell : UIView

@property (assign, nonatomic) BOOL isSelected;

- (instancetype)initWithCell:(MainHeaderViewItem *)item frame:(CGRect)frame;

- (void)setFont:(UIFont *)font;
- (void)setNormalTextColor:(UIColor *)textColor;
- (void)setSelectedTextColor:(UIColor *)textColor;

@end
