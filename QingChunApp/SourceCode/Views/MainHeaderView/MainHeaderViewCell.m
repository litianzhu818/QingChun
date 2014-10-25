//
//  MainHeaderViewCell.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "MainHeaderViewCell.h"

#define MARGIN_WIDTH 2.0f
#define LABEL_WIDTH (self.frame.size.height - 4*MARGIN_WIDTH)/4

@interface MainHeaderViewCell ()
{
    UIImageView *imageView;
    UILabel     *titleLabel;
    MainHeaderViewItem *_item;
    
    UIColor *normalColor;
    UIColor *selectedColor;
    
    BOOL _canselected;
    
    id<MainHeaderViewCellDelegate> _delegate;
}
@end

@implementation MainHeaderViewCell
@synthesize isSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCell:(MainHeaderViewItem *)item frame:(CGRect)frame delegate:(id)delegate;
{
    if (FRAME_H(frame) < 44.0) frame = CGRectMake(FRAME_TX(frame), FRAME_TY(frame), FRAME_W(frame), 44.0);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _item = item;
        isSelected = NO;
        _delegate = delegate;
        _canselected = YES;
        [self initUI];
        [self setUpUI];
    }
    return self;
}

- (void)removeDelegate:(id)delegate
{
    _delegate = nil;
}

- (void)initUI
{
    CGFloat labelHeight = LABEL_WIDTH;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setContentMode:UIViewContentModeCenter];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:imageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:8.0]];
    [self addSubview:titleLabel];

    NSMutableArray *Constraints = [NSMutableArray array];
    
    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-MARGIN1-[imageView]-MARGIN1-|"
                                                                             options:0
                                                                             metrics:@{
                                                                                       @"MARGIN1":[NSNumber numberWithFloat:MARGIN_WIDTH]
                                                                                       }
                                                                               views:NSDictionaryOfVariableBindings(imageView)]];
    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-MARGIN1-[titleLabel]-MARGIN1-|"
                                                                             options:0
                                                                             metrics:@{
                                                                                       @"MARGIN1":[NSNumber numberWithFloat:MARGIN_WIDTH]
                                                                                       }
                                                                               views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-MARGIN1-[imageView(==MARGIN2)]-MARGIN4-[titleLabel(==MARGIN3)]-MARGIN1-|"
                                                                             options:0
                                                                            metrics:@{@"MARGIN1":[NSNumber numberWithFloat:MARGIN_WIDTH],@"MARGIN2":[NSNumber numberWithFloat:2.5*labelHeight],@"MARGIN3":[NSNumber numberWithFloat:1.5*labelHeight],@"MARGIN4":[NSNumber numberWithFloat:2*MARGIN_WIDTH]}
                                                                               views:NSDictionaryOfVariableBindings(imageView,titleLabel)]];
    
    [self addConstraints:Constraints];

}

- (void)setUpUI
{
    if (!_item) {
        return;
    }
    [imageView setImage:_item.normalImage];
    [titleLabel setText:_item.title];
}

- (void)setSelectedStyle:(BOOL)canSelected
{
    _canselected = canSelected;
}

- (void)setFont:(UIFont *)font
{
    [titleLabel setFont:font];
}

- (void)setNormalTextColor:(UIColor *)textColor
{
    normalColor = textColor;
    isSelected ? NULL:[titleLabel setTextColor:textColor];
}
- (void)setSelectedTextColor:(UIColor *)textColor
{
    selectedColor = textColor;
    isSelected ? [titleLabel setTextColor:textColor]:NULL;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [titleLabel setTextColor:tintColor];
}

- (void)setIsSelected:(BOOL)_isSelected
{
    isSelected = _isSelected;
    
    if (_canselected) {
        [imageView setImage:(isSelected ? _item.selectedImage:_item.normalImage)];
        [titleLabel setTextColor:(isSelected ? selectedColor:normalColor)];
    }
    
    if (isSelected) {
        if (_delegate && [_delegate respondsToSelector:@selector(MainHeaderViewCell:didSelected:)]) {
            [_delegate MainHeaderViewCell:self didSelected:isSelected];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(MainHeaderViewCell:didChangedSelected:)]) {
        [_delegate MainHeaderViewCell:self didChangedSelected:isSelected];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //your code here
    // check touch up inside
    if ([self superview]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:[self superview]];
        //TODO:这里可以将触摸范围扩大，便于操作，例如：
        CGRect validTouchArea = CGRectMake((self.frame.origin.x - 10),
                                           (self.frame.origin.y - 10),
                                           (self.frame.size.width + 10),
                                           (self.frame.size.height + 10));
        if (CGRectContainsPoint(validTouchArea, point)) {
            //your code here
            self.alpha = 0.7;
            if (!isSelected && _canselected){
                [self setIsSelected:!isSelected];
            }else if(!_canselected){
                if (_delegate && [_delegate respondsToSelector:@selector(MainHeaderViewCell:didSelected:)]) {
                    [_delegate MainHeaderViewCell:self didSelected:isSelected];
                }
            }
        }
    }

    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //your code here
    
    self.alpha = 1.0;
    
    [super touchesEnded:touches withEvent:event];
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
