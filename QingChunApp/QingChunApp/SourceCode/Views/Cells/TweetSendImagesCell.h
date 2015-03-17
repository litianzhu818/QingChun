//
//  TweetSendImagesCell.h
//  QingChunApp
//
//  Created by Peter Lee on 15/3/12.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetSendImagesCell : UITableViewCell

@property (copy, nonatomic) void(^addPicturesBlock)();

+ (CGFloat)cellHeightWithObj:(id)obj;

@end
