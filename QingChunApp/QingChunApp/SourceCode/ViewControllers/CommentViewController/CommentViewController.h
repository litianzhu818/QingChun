//
//  CommentViewController.h
//  QingChunApp
//
//  Created by Peter Lee on 15/3/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "BaseViewController.h"

@class CellDisplayModel;
@interface CommentViewController : BaseViewController

@property (strong,nonatomic) void (^block)(id model);

- (id)initWithModel:(id)model block:(void(^)(id object))block;

@end
