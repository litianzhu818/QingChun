//
//  UserHeaderView.h
//  QingChunApp
//
//  Created by  李天柱 on 14/11/6.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserHeaderViewDelegate;

@interface UserHeaderView : UIView
{
    id<UserHeaderViewDelegate> delegate;
}
@property (assign, nonatomic) id<UserHeaderViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *accessoryButton;

+ (instancetype)instanceFromNib;

-(IBAction)clikedOnHeaderView:(id)sender;
-(IBAction)clikedOnAccessroyView:(id)sender;

@end

@protocol UserHeaderViewDelegate <NSObject>

@optional

- (void)userHeaderView:(UserHeaderView *)userHeaderView didClikedOnButton:(UIButton *)button;

@end