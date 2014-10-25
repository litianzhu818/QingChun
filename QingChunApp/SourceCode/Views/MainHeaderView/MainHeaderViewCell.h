//
//  MainHeaderViewCell.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHeaderViewItem.h"

@protocol MainHeaderViewCellDelegate;

@interface MainHeaderViewCell : UIView

@property (assign, nonatomic) BOOL isSelected;

- (instancetype)initWithCell:(MainHeaderViewItem *)item frame:(CGRect)frame delegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

- (void)setSelectedStyle:(BOOL)canSelected;

- (void)setFont:(UIFont *)font;
- (void)setNormalTextColor:(UIColor *)textColor;
- (void)setSelectedTextColor:(UIColor *)textColor;

@end

@protocol MainHeaderViewCellDelegate <NSObject>

@optional

- (void)MainHeaderViewCell:(MainHeaderViewCell *)mainHeaderViewCell didSelected:(BOOL)selected;
- (void)MainHeaderViewCell:(MainHeaderViewCell *)mainHeaderViewCell didChangedSelected:(BOOL)selected;
@end
