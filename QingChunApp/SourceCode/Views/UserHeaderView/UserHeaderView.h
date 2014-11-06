//
//  UserHeaderView.h
//  QingChunApp
//
//  Created by  李天柱 on 14/11/6.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *accessoryButton;
//@property (weak, nonatomic) IBOutlet *<#name#>;
//@property (weak, nonatomic) IBOutlet *<#name#>;
//@property (weak, nonatomic) IBOutlet *<#name#>;
//@property (weak, nonatomic) IBOutlet *<#name#>;
//@property (weak, nonatomic) IBOutlet *<#name#>;

-(IBAction)clikedOnHeaderView:(id)sender;
-(IBAction)clikedOnAccessroyView:(id)sender;
@end
