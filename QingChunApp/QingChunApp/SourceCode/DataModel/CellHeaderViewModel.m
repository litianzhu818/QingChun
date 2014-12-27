//
//  CellHeaderViewModel.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellHeaderViewModel.h"
#import "NSObject+AutoProperties.h"

@implementation CellHeaderViewModel

- (instancetype)initWithName:(NSString *)name time:(NSString *)time text:(NSString *)text imageUrl:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        self.name = name;
        self.time = time;
        self.text = text;
        self.imageUrl = imageUrl;
    }
    return self;
}
/*
-(NSString *)description
{
    //Add your code here
    //Such as the code here
    return [NSString stringWithFormat:@"\tCellHeaderViewModel:\tname:%@\ttime:%@\ttext:%@\timageUrl:%@\t}",self.name,self.time,self.text,self.imageUrl];
}
#pragma mark -
#pragma mark NSCopying Methods
- (id)copyWithZone:(NSZone *)zone
{
    CellHeaderViewModel *newObject = [[[self class] allocWithZone:zone] init];
    //Here is a sample for using the NScoding method
    //Add your code here
    [newObject setName:self.name];
    [newObject setText:self.text];
    [newObject setTime:self.time];
    [newObject setImageUrl:self.imageUrl];
    
    return newObject;
}

#pragma mark -
#pragma mark NSCoding Methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //Here is a sample for using the NScoding method
    //Add your code here
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        //Here is a sample for using the NScoding method
        //Add your code here
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
    }
    return  self;
}
*/


@end
