//
//  MainHeaderViewItem.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MainHeaderViewItem : NSObject

@property (readonly, strong, nonatomic) UIImage     *normalImage;
@property (readonly, strong, nonatomic) UIImage     *selectedImage;
@property (readonly, strong, nonatomic) NSString    *title;

- (instancetype)initWithTitle:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;

@end
