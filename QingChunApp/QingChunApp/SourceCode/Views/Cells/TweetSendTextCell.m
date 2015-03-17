//
//  TweetSendTextCell.m
//  QingChunApp
//
//  Created by Peter Lee on 15/3/12.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "TweetSendTextCell.h"
#import "UIPlaceHolderTextView.h"
#import "UIView+Custom.h"

#define TweetContentCell_ContentFont [UIFont systemFontOfSize:16]

#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface TweetSendTextCell () <UITextViewDelegate>

@property (strong, nonatomic) UIPlaceHolderTextView *tweetContentView;

@end

@implementation TweetSendTextCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_tweetContentView) {
            _tweetContentView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(7, 7, Screen_Width-7*2, [TweetSendTextCell CellHeight]-10)];
            _tweetContentView.font = TweetContentCell_ContentFont;
            _tweetContentView.delegate = self;
            _tweetContentView.placeholder = @"说点什么吧...";
            _tweetContentView.returnKeyType = UIReturnKeyDefault;
            [self.contentView addSubview:_tweetContentView];
        }
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    return self;
}

+ (CGFloat)CellHeight{
    
    CGFloat cellHeight = 95;
    
    return cellHeight;
}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView{
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(textView.text);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //    if ([text isEqualToString:@"\n"]) {
    //        [_tweetContentView resignFirstResponder];
    //        return NO;
    //    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    [kKeyWindow addSubview:self.keyboardToolBar];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    [self.keyboardToolBar removeFromSuperview];
    return YES;
}

#pragma mark - KeyBoard Notification Handlers
- (void)keyboardChange:(NSNotification*)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"userInfo------------------:%@", userInfo);
    [UIView animateWithDuration:animationDuration delay:0.0f
                        options:[UIView animationOptionsForCurve:animationCurve]
                     animations:^{
        CGFloat keyboardY =  keyboardEndFrame.origin.y;
//        [self.keyboardToolBar setY:keyboardY- CGRectGetHeight(self.keyboardToolBar.frame)];
    } completion:^(BOOL finished) {
    }];
}




@end
