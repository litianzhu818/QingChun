//
//  UINavigationBar+ImageBackground.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/21.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

@import UIKit;

@interface UINavigationBar(ImageBackground)

- (void)setVerticalBackgroundImage:(UIImage *)verticalBackgroundImage
          landscapeBackgroundImage:(UIImage *)landscapeBackgroundImage
                    withShadowLine:(BOOL)shadowLine;

@end
