//
//  MJPhotoToolbar.h
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MJPhotoToolbarDelegate;

@interface MJPhotoToolbar : UIView
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (assign, nonatomic) id<MJPhotoToolbarDelegate> delegate;

- (void)setMenuButtonStatus:(BOOL)avlible;

@end

@protocol MJPhotoToolbarDelegate <NSObject>

- (void)showActionMenu;

@end
