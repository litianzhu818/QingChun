//
//  NSObject+ Description.m
//  QingChunApp
//
//  Created by  李天柱 on 15/1/1.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "NSObject+Description.h"
#import <objc/runtime.h>

static NSSet *excludedPropertyNames;

@implementation NSObject (Description)

+ (void)load
{
    excludedPropertyNames = [NSSet setWithArray:@[@"hash", @"superclass", @"description", @"debugDescription"]];
}

- (NSArray *)autoPropertiesDescriptionInArrayFormForClassType:(Class)classType
{
    NSMutableArray *properties = [NSMutableArray array];
    
    // Find Out something about super Classes
    Class superClass  = class_getSuperclass(classType);
    if  ( superClass != nil && ![superClass isEqual:[NSObject class]]) {
        
        // Append all the super class's properties to the result (Reqursive, until NSObject)
        [properties addObjectsFromArray:[self autoPropertiesDescriptionInArrayFormForClassType:superClass]];
    }
    
    // Add Information about Current Properties
    unsigned int property_count;
    objc_property_t *property_list = class_copyPropertyList(classType, &property_count); // Must Free, later
    
    for (int i = 0; i < property_count; i++) {
        // Reverse order, to get Properties in order they were defined
        
        objc_property_t property = property_list[i];
        
        // For Eeach property we are loading its name
        const char * property_name = property_getName(property);
        
        NSString * propertyName = [NSString stringWithCString:property_name encoding:NSUTF8StringEncoding];
        
        if (propertyName && ![excludedPropertyNames containsObject:propertyName]) {
            // and if name is ok, we are getting value using KVC
            id value = [self valueForKey:propertyName];
            
            // format of result items: p1 = v1; p2 = v2; ...
            [properties addObject:[NSString stringWithFormat:@"%@ = %@", propertyName, value]];
        }
    }
    
    free(property_list);//Clean up
    
    return [properties copy];
}

- (NSString *)autoDescriptionForClassType:(Class)classType
{
    return [[self autoPropertiesDescriptionInArrayFormForClassType:self.class] componentsJoinedByString:@", "];
}

// Reflects about self.
- (NSString *)autoDescription
{
    return [NSString stringWithFormat:@"<%@: %@>",
            NSStringFromClass([self class]), [self autoDescriptionForClassType:[self class]]];
}


@end
