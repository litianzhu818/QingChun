//
//  UserHeaderView.m
//  QingChunApp
//
//  Created by  李天柱 on 14/11/6.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "UserHeaderView.h"
#import "UserInfoModel.h"
#import "UIImageView+WebCache.h"

#define DEFAULT_NAME_LABEL_WIDTH 180.0f

@interface UserHeaderView ()
{
    UserInfoModel                   *_userInfo;
    BOOL                            _hasUserInfo;
    
    UIColor                         *_customBackgroundColor;
}

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beanCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *beanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImageView;


@property (weak, nonatomic) IBOutlet UIButton *accessoryButton;

@end

@implementation UserHeaderView
@synthesize userInfo = _userInfo;

+ (instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil]firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI
{
    [self loadViews];
}

- (void)loadViews
{
    _customBackgroundColor = self.backgroundColor;
    if (_hasUserInfo) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    [_accessoryButton setBackgroundImage:[UIImage imageNamed:@"header_ac_nor"] forState:UIControlStateNormal];
    [_accessoryButton setBackgroundImage:[UIImage imageNamed:@"header_ac_se"] forState:UIControlStateSelected];
    
    [self.userNameLabel setTextColor:UIColorFromRGB(0x61a653)];
    [self.beanCountLabel setTextColor:UIColorFromRGB(0x757575)];
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 4.0f;
    //self.headerImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.userDefaultImgURLStr]
                            placeholderImage:[UIImage imageNamed:@"headerImage"]
                                     options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    
    self.gradeImageView.image = [UIImage imageNamed:[self gradeImageWithGrade:self.userInfo.userGrade]];
    
    [self displayUserInfo:_hasUserInfo];
    
}

- (void)displayUserInfo:(BOOL)display
{
    [self.infoLabel setHidden:display];
    
    [self.userNameLabel setHidden:!display];
    [self.beanCountLabel setHidden:!display];
    [self.beanImageView setHidden:!display];
    [self.gradeImageView setHidden:!display];
}

-(IBAction)clikedOnHeaderView:(id)sender
{
    LOG(NSStringFromClass([_delegate class]));
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeaderView:didClikedOnButton:hasUserInfo:)]) {
        [self.delegate userHeaderView:self didClikedOnButton:sender hasUserInfo:_hasUserInfo];
    }
}
- (void)cliked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeaderView:didClikedOnButton:hasUserInfo:)]) {
        [self.delegate userHeaderView:self didClikedOnButton:sender hasUserInfo:_hasUserInfo];
    }
}

-(IBAction)clikedOnAccessroyView:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeaderView:didClikedOnButton:hasUserInfo:)]) {
        [self.delegate userHeaderView:self didClikedOnButton:sender hasUserInfo:_hasUserInfo];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.userInfo) return;
    
    self.beanCountLabel.text = [NSString stringWithFormat:@"%d",self.userInfo.userBean];
    self.userNameLabel.text = self.userInfo.userName;
    
    self.gradeImageView.image = [UIImage imageNamed:[self gradeImageWithGrade:self.userInfo.userGrade]];
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.userDefaultImgURLStr]
                            placeholderImage:[UIImage imageNamed:@"headerImage"]
                                     options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    //重新设置userNameLabel 和 gradeImageView的frame
    CGRect userNameLabelFrame = self.userNameLabel.frame;
    CGRect gradeImageViewFrame = self.gradeImageView.frame;
    
    CGFloat userNameLabelWith = [self sizeOfLabelWithString:self.userNameLabel.text font:self.userNameLabel.font height:userNameLabelFrame.size.height].width;
    userNameLabelFrame.size.width = userNameLabelWith;
    gradeImageViewFrame.origin.x = userNameLabelFrame.origin.x + userNameLabelWith + 8.0f;
    
    self.userNameLabel.frame = userNameLabelFrame;
    self.gradeImageView.frame = gradeImageViewFrame;
    
    //根据情况影藏或者显示控件
    [self displayUserInfo:_hasUserInfo];
    
    //设置背景颜色
    self.backgroundColor = _hasUserInfo ? [UIColor clearColor]:_customBackgroundColor;
}

- (NSString *)gradeImageWithGrade:(NSUInteger)grade
{
    NSString *imageName = nil;
    switch (grade) {
        case 2:
            imageName = @"qcd_grade_2";
            break;
        case 3:
            imageName = @"qcd_grade_3";
            break;
        case 4:
            imageName = @"qcd_grade_4";
            break;
        case 5:
            imageName = @"qcd_grade_5";
            break;
        default:
            imageName = @"qcd_nor";//@"qcd_grade_1";
            break;
    }
    
    return imageName;
}

- (CGSize)sizeOfLabelWithString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    
    CGSize labelSize = CGSizeMake(0.0, 0.0);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle.copy
                                 };
    
    labelSize =  [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributes
                                      context:nil].size;
    
    labelSize.width = (labelSize.width <= DEFAULT_NAME_LABEL_WIDTH) ? labelSize.width:DEFAULT_NAME_LABEL_WIDTH;
    
    return labelSize;
}


#pragma mark - 属性方法
- (void)setUserInfo:(UserInfoModel *)userInfo
{
    if (userInfo) {
        _userInfo = userInfo;
        _hasUserInfo = YES;
        [self setNeedsLayout];
    }
}

- (void)updateWithUserInfoModel:(UserInfoModel *)userInfo
{
    if (userInfo) {
        _userInfo = userInfo;
        _hasUserInfo = YES;
        [self setNeedsLayout];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
