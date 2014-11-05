//
//  InfoTableViewCell.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/27.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
{
    IBOutlet UIButton *photoButton;
    IBOutlet UIButton *detailButton;
    IBOutlet UIButton *zhanButton;
    IBOutlet UIButton *tuButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *commentButton;
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *textlabel;
    IBOutlet UIImageView *photoView;
}

@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIButton *zhanButton;
@property (weak, nonatomic) IBOutlet UIButton *tuButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

+ (instancetype)instanceFromNib;

@end
