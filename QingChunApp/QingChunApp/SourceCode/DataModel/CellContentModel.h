//
//  CellContentModel.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellContentModel : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic, readonly) NSString *time;

+ (id)cellContentModelWithID:(NSString *)ID time:(NSString *)time text:(NSString *)text;

- (id)initWithID:(NSString *)ID time:(NSString *)time text:(NSString *)text;

@end
