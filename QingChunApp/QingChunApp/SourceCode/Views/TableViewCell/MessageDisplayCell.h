//
//  MessageDisplayCell.h
//  QingChunApp
//
//  Created by  李天柱 on 15/1/1.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "BaseTableViewCell.h"

@import Foundation;

@class CellDisplayModel;
@protocol MessageDisplayCellDelegate;

typedef NS_ENUM(NSUInteger, MessageDisplayCellType) {
    MessageDisplayCellTypeNormal = 0,
     MessageDisplayCellTypeIndent
};


@interface MessageDisplayCell : BaseTableViewCell

@property (strong, nonatomic) CellDisplayModel *cellDisPlayModel;

@property (assign, nonatomic) MessageDisplayCellType messageDisplayCellType;

@property (copy, nonatomic) void (^likeBlock)(id model);
@property (copy, nonatomic) void (^shareBlock)(id model);
@property (copy, nonatomic) void (^commentBlock)(id model);
@property (weak, nonatomic) id<MessageDisplayCellDelegate> delegate;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellFrameHeightWithWidth:(CGFloat)width cellDisplayModel:(CellDisplayModel *)cellDisplayModel;

@end

@protocol MessageDisplayCellDelegate <NSObject>

@required

@optional

- (void)messageDisplayCell:(MessageDisplayCell *)cell didLikeCellDisplayModel:(CellDisplayModel *)model;
- (void)messageDisplayCell:(MessageDisplayCell *)cell didShareCellDisplayModel:(CellDisplayModel *)model;
- (void)messageDisplayCell:(MessageDisplayCell *)cell didCommentCellDisplayModel:(CellDisplayModel *)model;

@end