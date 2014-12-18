//
//  BaseCellHeaderView.h
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellHeaderViewModel.h"

typedef NS_ENUM(NSUInteger, CellHeaderPhotoType) {
    CellHeaderPhotoTypeSquare = 0,
    CellHeaderPhotoTypeCircle
};

typedef NS_ENUM(NSUInteger, CellHeaderType) {
    CellHeaderTypeSimple = 0,
    CellHeaderTypeMultiple
};

@protocol BaseCellHeaderViewDelegate;

@interface BaseCellHeaderView : UIView

@property (assign, nonatomic) id<BaseCellHeaderViewDelegate> delegate;
@property (assign, nonatomic, readonly) CGSize headerSize;
@property (strong, nonatomic, readonly) CellHeaderViewModel *headerViewModel;

- (id)initWithFrame:(CGRect)frame cellHeaderViewModel:(CellHeaderViewModel *)headerViewModel;

- (id)initWithMultipleTypeFrame:(CGRect)frame
            cellHeaderViewModel:(CellHeaderViewModel *)headerViewModel
            cellHeaderPhotoType:(CellHeaderPhotoType)photoType;

- (id)initWithSimpleTypeFrame:(CGRect)frame
          cellHeaderViewModel:(CellHeaderViewModel *)headerViewModel
          cellHeaderPhotoType:(CellHeaderPhotoType)photoType;

@end




@protocol BaseCellHeaderViewDelegate <NSObject>

@optional

- (void)baseCellHeaderView:(BaseCellHeaderView *)baseCellHeaderView clikedOnPhotoButton:(id)sender;
- (void)baseCellHeaderView:(BaseCellHeaderView *)baseCellHeaderView clikedOnMoreButton:(id)sender;

@end


