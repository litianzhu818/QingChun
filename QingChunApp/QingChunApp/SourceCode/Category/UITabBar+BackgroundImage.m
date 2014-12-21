//
//  UITabBar+BackgroundImage.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/21.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "UITabBar+BackgroundImage.h"
#import "UIImage+SA.h"

@implementation UITabBar(BackgroundImage)

- (void)hidenShadowLine:(BOOL)hiden
{
    if (hiden && [self respondsToSelector:@selector(setShadowImage:)]) {
        
        [self setShadowImage:[UIImage imageWithColor:[ UIColor clearColor ] size: CGSizeMake (320 , 3)]];
    }
}

- (void)setTabBarItemsTitleNormalColor:(UIColor *)normalColor
                            normalFont:(UIFont *)normalFont
                         selectedColor:(UIColor *)selectedColor
                          selectedFont:(UIFont *)selectedFont
                    positionAdjustment:(UIOffset)adjustment
{
    [self setTintColor:selectedColor];
    
    //Load TabBarText
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITabBarItem *item = obj;
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:selectedColor,NSForegroundColorAttributeName,selectedFont,NSFontAttributeName, nil] forState:UIControlStateSelected];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:normalColor,NSForegroundColorAttributeName,normalFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
        [item setTitlePositionAdjustment:adjustment];
        
    }];
}

- (void)setTabBarItemsNormalImages:(NSArray *)normalImages selectedImages:(NSArray *)selectedImages
{
    //Load TabBarImage
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITabBarItem *item = obj;
        item.image = [[normalImages objectAtIndex:idx] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
        item.selectedImage = [[selectedImages objectAtIndex:idx] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
}
- (void)setTabBarItemsNormalImageNames:(NSArray *)normalImageNames selectedImageNames:(NSArray *)selectedImageNames
{
    //Load TabBarImage
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITabBarItem *item = obj;
        item.image = [[UIImage imageNamed:[normalImageNames objectAtIndex:idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
        item.selectedImage = [[UIImage imageNamed:[selectedImageNames objectAtIndex:idx]]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
