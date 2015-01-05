//
//  MainHeaderView.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainHeaderViewDelegate;

@interface MainHeaderView : UIView

- (instancetype)initWithItems:(NSArray *)items frame:(CGRect)frame delegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

- (void)setSelectedAtIndex:(NSUInteger)index;
- (NSUInteger)selectedItem;

@end


@protocol MainHeaderViewDelegate <NSObject>

@optional
- (void)didClikedAtFirstIndex;
- (void)didClikedAtLastIndex;
- (void)MainHeaderView:(MainHeaderView *)mainHeaderView didSelectedAtIndex:(NSUInteger)index;
@end