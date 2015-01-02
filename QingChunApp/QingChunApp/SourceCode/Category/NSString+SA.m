//
//  NSString+SA.m
//  SianWeibo
//
//  Created by yusian on 14-4-12.
//  Copyright (c) 2014年 小龙虾论坛. All rights reserved.
//  自定义字符串拼接方法

#import "NSString+SA.h"

@implementation NSString (SA)

- (NSString *)fileAppend:(NSString *)string
{
    // 1、获取文件扩展名
    NSString *ext = [self pathExtension];
    
    // 2、去掉文件扩展名
    NSString *str = [self stringByDeletingPathExtension];
    
    // 3、拼接新加字符串
    str = [str stringByAppendingString:string];
    
    // 4、拼接扩展名
    str = [str stringByAppendingPathExtension:ext];
    
    return str;

}
//计算字体在label中的高
- (CGSize)sizeWithWidth:(CGFloat)width
                   font:(UIFont *)font
          lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    //  //该方法已经弃用
    //    CGSize size = [sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    //paragraphStyle.lineSpacing = 5.0;//调整行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle.copy
                                 };
    
    return  [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:attributes
                                 context:nil].size;
}


@end
