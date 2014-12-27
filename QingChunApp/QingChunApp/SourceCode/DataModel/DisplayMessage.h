//
//  DisplayMessage.h
//  QingChunApp
//
//  Created by  李天柱 on 14/11/4.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DisplayMessage : NSObject 

//The description string of this object
//@property (readonly, copy) NSString *description;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger ID;

@end
