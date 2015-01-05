//
//  BaseTableViewCellView.h
//  QingChunApp
//
//  Created by Peter Lee on 14/12/16.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, CellViewType) {
    CellViewTypeTextOnly = 0,
    CellViewTypeSinglePicture,
    CellViewTypeMultiplePicture
};

typedef NS_ENUM(NSUInteger, LayoutType) {
    LayoutTypeTile = 0,
    LayoutTypeIndent
};

@interface BaseTableViewCellView : UIView

//The size of this view
@property (assign, nonatomic, readonly) CGSize viewSize;
@property (assign, nonatomic, readonly) CellViewType cellViewType;
@property (strong, nonatomic, readonly) UIColor *backgrounColor;

- (id)initWithFrame:(CGRect)frame;

@end
