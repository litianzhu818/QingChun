//
//  AppDelegate.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/9.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NetStatusManager.h"

typedef NS_ENUM(NSInteger, NetworkStatusType){
    NetworkStatusDefaultType = 0,
    NetworkStatusNoInternetType
};


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) NetworkStatusType networkStatus;
/**
 *  设置系统window的根视图控制器
 *
 *  @param viewController 跟视图控制器
 */
-(void)setApplicationRootViewController:(UIViewController *)viewController;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//
//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;


@end

