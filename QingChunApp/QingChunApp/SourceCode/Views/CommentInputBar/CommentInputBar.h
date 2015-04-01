//
//  CommentInputBar.h
//  QingChunApp
//
//  Created by Peter Lee on 15/3/31.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPGrowingTextView;

@interface CommentInputBar : UIImageView

@property (weak, nonatomic, readonly)   UIView                  *inView;
@property (weak, nonatomic)             UIPanGestureRecognizer  *panGestureRecognizer;
@property (strong, nonatomic)           HPGrowingTextView       *inputTextView;
@property (strong, nonatomic)           UIButton                *sendButton;
@property (assign, nonatomic)           BOOL hasSendBtn;
@property (strong, nonatomic)           UIImage *bgImage;
@property (strong, nonatomic)           UIImage *btnNormalImage;
@property (strong, nonatomic)           UIImage *btnhighlightedImage;
@property (strong, nonatomic)           NSString *btnTitle;
@property (strong, nonatomic)           NSString *placeHolder;
@property (copy, nonatomic)             void (^sendBlock) (NSString *message);

- (id)initWithPanGesture:(UIPanGestureRecognizer *)panGesture
                  inView:(UIView *)inView
                 bgImage:(UIImage *)bgImage
             placeHolder:(NSString *)placeHolder
              hasSendBtn:(BOOL)hasSendBtn
                btnTitle:(NSString *)btnTitle
          btnNormalImage:(UIImage *)btnNormalImage
     btnhighlightedImage:(UIImage *)btnhighlightedImage
               sendBlock:(void (^)(NSString *messgae))sendBlock;

- (void)resignFirstResponder;

+ (CGFloat)barHeight;

@end

