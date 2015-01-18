//
//  QCBellDataModel.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/9.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface QCBellDataModel : NSObject

@property (strong, nonatomic, readonly) UIImage     *image;
@property (strong, nonatomic, readonly) NSString    *title;
@property (assign, nonatomic, readonly) NSUInteger  number;
@property (assign, nonatomic, readonly) NSUInteger  tag;


+ (id)qcbellDataModel;
+ (id)qcbellDataModelWithImage:(UIImage *)image title:(NSString *)title;
+ (id)qcbellDataModelWithImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number;
+ (id)qcbellDataModelWithImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number tag:(NSUInteger)tag;

- (instancetype)init;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number tag:(NSUInteger)tag;

- (void)updateNumber:(NSUInteger)number;
- (void)updateImage:(UIImage *)image title:(NSString *)title;
- (void)updateImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number;
- (void)updateImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number tag:(NSUInteger)tag;

@end
