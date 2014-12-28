//
//  CellHeaderViewModel.h
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellHeaderViewModel : NSObject

@property (strong, nonatomic)   NSString  *name;
@property (strong, nonatomic)   NSString  *time;
@property (strong, nonatomic)   NSString  *text;
@property (readonly, nonatomic) NSString  *imageUrl;
@property (strong, nonatomic)   NSString *imageUrlPrefix;
@property (strong, nonatomic)   NSString  *imageUrlSuffix;

- (instancetype)initWithName:(NSString *)name
                        time:(NSString *)time
                        text:(NSString *)text
                    imageUrl:(NSString *)imageUrl;

@end
