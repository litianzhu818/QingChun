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


typedef NS_ENUM(NSUInteger, MessageDisplayCellType) {
    MessageDisplayCellTypeNormal = 0,
     MessageDisplayCellTypeIndent
};


@interface MessageDisplayCell : BaseTableViewCell

@property (strong, nonatomic) CellDisplayModel *cellDisPlayModel;

@property (assign, nonatomic) MessageDisplayCellType messageDisplayCellType;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellFrameHeightWithWidth:(CGFloat)width cellDisplayModel:(CellDisplayModel *)cellDisplayModel;

@end
