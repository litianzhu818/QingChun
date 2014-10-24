//
//  NavigationBarItem.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "NavigationBarItem.h"

@implementation NavigationBarItem

-(instancetype)initWithTitle:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage
{
    self = [super init];
    if (self) {
        [self setNormalImage:normalImage];
        [self setSelectedImage:selectedImage];
        [self setTitle:title];
    }
    
    return self;
}
#pragma mark -
#pragma mark NSCopying Methods
- (id)copyWithZone:(NSZone *)zone
{
    NavigationBarItem *newObject = [[[self class] allocWithZone:zone] init];
    //Here is a sample for using the NScoding method
    //Add your code here
    [newObject setNormalImage:self.normalImage];
    [newObject setSelectedImage:self.selectedImage];
    [newObject setTitle:self.title];
    
    return newObject;
}

#pragma mark -
#pragma mark NSCoding Methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //Here is a sample for using the NScoding method
    //Add your code here
    [aCoder encodeObject:self.normalImage forKey:@"normalImage"];
    [aCoder encodeObject:self.selectedImage forKey:@"selectedImage"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        //Here is a sample for using the NScoding method
        //Add your code here
        self.normalImage = [aDecoder decodeObjectForKey:@"normalImage"];
        self.selectedImage = [aDecoder decodeObjectForKey:@"selectedImage"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        
    }
    return  self;
}



@end
