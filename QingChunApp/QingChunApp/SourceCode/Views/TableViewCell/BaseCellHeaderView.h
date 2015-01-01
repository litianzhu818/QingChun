//
//  BaseCellHeaderView.h
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CellHeaderViewType) {
    CellHeaderViewTypeNormal = 0,
    CellHeaderViewTypeIndent
};

@class CellDisplayModel;

@protocol BaseCellHeaderViewDelegate;

@interface BaseCellHeaderView : UIView

@property (strong, nonatomic) CellDisplayModel *cellDisplayModel;

@property (assign, nonatomic) id<BaseCellHeaderViewDelegate> delegate;

@property (assign, nonatomic, readonly) CellHeaderViewType cellHeaderViewType;


- (id)initWithFrame:(CGRect)frame
   cellDisplayModel:(CellDisplayModel *)cellDisplayModel;

- (id)initWithIndentTypeFrame:(CGRect)frame
          cellDisplayModel:(CellDisplayModel *)cellDisplayModel;

- (id)initWithNormalTypeFrame:(CGRect)frame
          cellDisplayModel:(CellDisplayModel *)cellDisplayModel;

- (id)initWithFrame:(CGRect)frame
 cellHeaderViewType:(CellHeaderViewType)cellHeaderViewType
cellDisplayModel:(CellDisplayModel *)headerViewModel;


+ (CGFloat)normalHeaderViewHeightWithWidth:(CGFloat)width content:(NSString *)content;
+ (CGFloat)indentHeaderViewHeightWithWidth:(CGFloat)width content:(NSString *)content;
+ (CGFloat)headerViewHeightWithWidth:(CGFloat)width
                  cellHeaderViewType:(CellHeaderViewType)cellHeaderViewType
                             content:(NSString *)content;


@end




@protocol BaseCellHeaderViewDelegate <NSObject>

@optional

- (void)baseCellHeaderView:(BaseCellHeaderView *)baseCellHeaderView clikedOnPhotoButton:(id)sender;
- (void)baseCellHeaderView:(BaseCellHeaderView *)baseCellHeaderView clikedOnMoreButton:(id)sender;

@end


