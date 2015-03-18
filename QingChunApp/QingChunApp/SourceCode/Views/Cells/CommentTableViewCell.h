//
//  CommentTableViewCell.h
//  QingChunApp
//
//  Created by Peter Lee on 15/3/18.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "BaseTableViewCell.h"

@class CellCommentModel;
@class TTTAttributedLabel;

@interface CommentTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) TTTAttributedLabel *nameLabel;
@property (strong, nonatomic) TTTAttributedLabel *commentContentLabel;
@property (strong, nonatomic) TTTAttributedLabel *floorNumberLabel;

@property (strong, nonatomic) CellCommentModel *commentModel;

+ (CGFloat)cellHeightWithModel:(CellCommentModel *)model;

@end
