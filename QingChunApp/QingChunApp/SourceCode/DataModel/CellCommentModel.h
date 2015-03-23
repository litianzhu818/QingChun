//
//  CellCommentModel.h
//  QingChunApp
//
//  Created by Peter Lee on 15/3/18.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellCommentModel : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *message;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *headImageUrl;
@property (assign, nonatomic) NSString *floors;

@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *uid;

- (id)initWithDictionary:(NSDictionary *)dic;
- (void)updateWithDictionary:(NSDictionary *)dic;


@end
