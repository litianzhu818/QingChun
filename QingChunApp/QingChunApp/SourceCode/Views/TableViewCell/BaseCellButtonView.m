//
//  BaseCellButtonView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseCellButtonView.h"
#import "CellButtonViewModel.h"

@interface BaseCellButtonView ()
{
    UIButton                *_likeButton;
    UIButton                *_unlikeButton;
    UIButton                *_shareButton;
    UIButton                *_commentButton;
    
    CellButtonViewModel     *_cellButtonViewModel;
    CAKeyframeAnimation     *_keyframeAnimation;
    
}
@end

@implementation BaseCellButtonView

#pragma mark - 1、初始化
- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame cellButtonViewModel:nil];
}

- (id)initWithFrame:(CGRect)frame  cellButtonViewModel:(CellButtonViewModel *)cellButtonViewModel
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
        // 设置Dock的尺寸位置
        CGFloat dockWidth = [UIScreen mainScreen].bounds.size.width - 2 * kCellMargins;
        self.frame = CGRectMake(0, kCellDefaultHeight - kCellMargins - kStatusDockHeight, dockWidth, kStatusDockHeight);
        */
        // Dock贴紧父控件底部，即保持在Cell底部
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        // 接受用户交互
        self.userInteractionEnabled = YES;
        
        [self initAnimation];
        [self setCellButtonViewModel:cellButtonViewModel];
        
    }
    return self;
}

- (void)initAnimation
{
    _keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    _keyframeAnimation.values = @[@(0.1),@(1.0),@(1.5)];
    _keyframeAnimation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    _keyframeAnimation.calculationMode = kCAAnimationLinear;
}

#pragma mark - 2、添加子控件
- (UIButton *)addButtonWithImage:(NSString *)imageName backgroundImage:(NSString *)backgroundImageName buttonIndex:(NSInteger)index
{
    // 按钮基本属性设置
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setTag:index];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];       // 文字颜色
    button.titleLabel.font = [UIFont systemFontOfSize:12];                          // 文字大小
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal]; // 按钮图标
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);                         // 图文间距
    
    // 按钮尺寸位置
    CGFloat buttonWidth = self.frame.size.width / 4;
    button.frame = CGRectMake(index * buttonWidth, 0, buttonWidth, self.frame.size.height);
    
    return button;
}

#pragma mark - 3、修改控件文字
// 如果有数值，将数值替代文字
- (void)setButton:(UIButton *)button withTitle:(NSString *)title forCounts:(NSUInteger)number
{
    if (number > 10000) {       // 一万条以上数据简约显示
        NSString *title = [NSString stringWithFormat:@"%.1f万", number / 10000.0];
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [button setTitle:title forState:UIControlStateNormal];
    } else if(number > 0) {     // 一万条以下数据显示实际数值
        [button setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)number] forState:UIControlStateNormal];
    } else {                    // 数值为0则显示文字
        [button setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark - 4、设置控件文字
-(void)setCellButtonViewModel:(CellButtonViewModel *)cellButtonViewModel
{
    _cellButtonViewModel = cellButtonViewModel;
    
    // 根据模型数据内容设置菜单栏按钮文字
    [self setButton:_likeButton withTitle:@"喜欢" forCounts:cellButtonViewModel.likeCount];
    [self setButton:_unlikeButton withTitle:@"讨厌" forCounts:cellButtonViewModel.unlikeCount];
    self setButton:_shareButton withTitle:@"转发" forCounts:cellButtonViewModel.shareCount
    [self setButton:_commentButton withTitle:@"评论" forCounts:cellButtonViewModel.commentCount];
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
