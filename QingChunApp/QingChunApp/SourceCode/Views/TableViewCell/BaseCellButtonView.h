//
//  BaseCellButtonView.h
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellButtonViewModel;

@interface BaseCellButtonView : UIImageView
{
    UIButton                *_likeButton;
    UIButton                *_unlikeButton;
    UIButton                *_shareButton;
    UIButton                *_commentButton;
    
    CellButtonViewModel     *_cellButtonViewModel;
    CAKeyframeAnimation     *_keyframeAnimation;
    
}

@property (strong, nonatomic) CellButtonViewModel *cellButtonViewModel;

- (id)initWithFrame:(CGRect)frame  cellButtonViewModel:(CellButtonViewModel *)cellButtonViewModel;

- (UIButton *)addButtonWithImage:(NSString *)imageName backgroundImage:(NSString *)backgroundImageName buttonIndex:(NSInteger)index;

- (void)setButton:(UIButton *)button withTitle:(NSString *)title forCounts:(NSUInteger)number;

@end
