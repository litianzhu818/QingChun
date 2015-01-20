//
//  UINavigationBar+ImageBackground.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/21.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "UINavigationBar+ImageBackground.h"
#import "UIImage+SA.h"

@implementation UINavigationBar(ImageBackground)

- (void)setVerticalBackgroundImage:(UIImage *)verticalBackgroundImage
          landscapeBackgroundImage:(UIImage *)landscapeBackgroundImage
                    withShadowLine:(BOOL)shadowLine
{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        if (verticalBackgroundImage) {
            [self setBackgroundImage:verticalBackgroundImage forBarMetrics:UIBarMetricsDefault];
        }
        if (landscapeBackgroundImage) {
            [self setBackgroundImage:landscapeBackgroundImage forBarMetrics:UIBarMetricsLandscapePhone];
        }
    }else{
        //ios 5.0之前版本...
    }
    
    if (!shadowLine && [self respondsToSelector:@selector(setShadowImage:)]){
        
        [self setShadowImage:[UIImage imageWithColor:[ UIColor clearColor ] size:CGSizeMake (320 , 3)]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
