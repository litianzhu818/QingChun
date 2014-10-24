//
//  MainHeaderView.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainHeaderViewDelegate <NSObject>

@optional

@end

@interface MainHeaderView : UIView

- (instancetype)initWithItems:(NSArray *)items frame:(CGRect)frame delegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

@end
