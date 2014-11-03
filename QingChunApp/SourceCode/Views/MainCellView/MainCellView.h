//
//  MainCellView.h
//  QingChunApp
//
//  Created by  李天柱 on 14-11-3.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MainCellViewType)
{
    MainCellViewTypeText = 0,
    MainCellViewTypePicture,
    MainCellViewTypePictureAndText,
    MainCellViewTypeVoice,
    MainCellViewTypeVideo
};

@interface MainCellView : UIView

@property (assign, nonatomic) CGFloat *viewWidth;

@property (strong, nonatomic) UIButton  *photoButton;
@property (strong, nonatomic) UILabel   *nameLabel;
@property (strong, nonatomic) UILabel   *timeLabel;
@property (strong, nonatomic) UIButton  *moreInfoButton;

@property (strong, nonatomic) UILabel   *textLabel;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UIButton *shitButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *commentButton;

@end
