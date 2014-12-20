//
//  CellButtonView.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/20.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseCellButtonView.h"

@protocol CellButtonViewDelegate;

@interface CellButtonView : BaseCellButtonView

@property (assign, nonatomic) id<CellButtonViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame  cellButtonViewModel:(CellButtonViewModel *)cellButtonViewModel;

@end

@protocol CellButtonViewDelegate <NSObject>

@required

@optional

- (void)cellButtonView:(CellButtonView *)cellButtonView didTouchUpInsideOnButtonIndex:(NSUInteger)index;

@end