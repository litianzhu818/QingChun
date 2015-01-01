//
//  MessageDisplayCell.m
//  QingChunApp
//
//  Created by  李天柱 on 15/1/1.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "MessageDisplayCell.h"
#import "<#header#>"

@implementation MessageDisplayCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setCellDisPlayModel:(CellDisplayModel *)cellDisPlayModel
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //add your code ...
}

#pragma mark - class public methods
+ (NSString *)cellIdentifier
{
    return [NSString stringWithFormat:@"%@",@"MessageDisplayCellIdentifier"];
}
+ (CGFloat)cellFrameHeight
{
    return 0.0;
}

@end
