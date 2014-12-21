//
//  UITabBar+BackgroundImage.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/21.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (BackgroundImage)

- (void)hidenShadowLine:(BOOL)hiden;
- (void)setTabBarItemsTitleNormalColor:(UIColor *)normalColor
                            normalFont:(UIFont *)normalFont
                         selectedColor:(UIColor *)selectedColor
                          selectedFont:(UIFont *)selectedFont
                    positionAdjustment:(UIOffset)adjustment;
- (void)setTabBarItemsNormalImages:(NSArray *)normalImages selectedImages:(NSArray *)selectedImages;
- (void)setTabBarItemsNormalImageNames:(NSArray *)normalImageNames selectedImageNames:(NSArray *)selectedImageNames;
@end
