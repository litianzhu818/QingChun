//
//  AppDelegate.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/9.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "SDWebImageManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "OtherSDKInfo.h"

@interface AppDelegate ()<NetStatusManagerDelegate, WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //获取启动信息
    [self registerRemoteNotificationWith:application];
    [self launchWitchRemoteNotification:launchOptions];
    //FIXME: we should not set the applicationIconBadgeNumber of the application to 0 here
    application.applicationIconBadgeNumber = 0;
    [self startCheckNetwork];
    [self startEngine];
    [self startReadPlistFiles];
    [self initData];
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //send the deviceToken
//    NSString* device_token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    [[UserConfig sharedInstance] SetDeviceToken:device_token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    LOG(@"Push Register Error:%@", error.description);
}

-(void)launchWitchRemoteNotification:(NSDictionary *)startInfoDic
{
    NSDictionary* launchDic = [startInfoDic objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (launchDic){//从远端推送启动的
        
    }
}
/*
//判断启动信息
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
 {
    if(!url){
        return NO;
    }
    //Kissnapp://
    //LOG(@"Calling Application Bundle ID: %@", sourceApplication);
    LOG(@"URL scheme:%@", [url scheme]);
    LOG(@"URL query: %@", [url query]);
    NSString *infoString = [url query];
    switch ([infoString integerValue]) {
        case 101:
            [NotificationCenter postNotificationName:EMAIL_REGISTER_SUCCEED object:infoString];
            break;

        default:
            break;
    }
    return YES;
}
 */


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = NO;
    
    if (!url) return result;
    
    if ([[url scheme] isEqualToString:WeiBoAppURLScheme]) {
        result = [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([[url scheme] isEqualToString:TenCentAppURLScheme]){
        result = [TencentOAuth HandleOpenURL:url];
    }
    
    return result;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = NO;
    
    if (!url) return result;
    
    if ([[url scheme] isEqualToString:WeiBoAppURLScheme]) {
        result = [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([[url scheme] isEqualToString:TenCentAppURLScheme]){
        result = [TencentOAuth HandleOpenURL:url];
    }

    /*
    LOG(@"Calling Application Bundle ID: %@\nURL scheme:%@\nURL query: %@", sourceApplication,[url scheme],[url query]);
    NSString *infoString = [url query];
    switch ([infoString integerValue]) {
        case 101:
            [NotificationCenter postNotificationName:EMAIL_REGISTER_SUCCEED object:infoString];
            break;
            
        default:
            break;
    }
     */
    return result;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //TODO:处理界面跳转
    LOG(@"收到远程推送：%@",userInfo.description);
    
    NSString* alertStr = nil;
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    NSObject *alert = [apsInfo objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSString class]]){
        alertStr = (NSString*)alert;
    }
    else if ([alert isKindOfClass:[NSDictionary class]]){
        NSDictionary* alertDict = (NSDictionary*)alert;
        alertStr = [alertDict objectForKey:@"body"];
    }
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    if ([application applicationState] == UIApplicationStateActive && alertStr != nil){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pushed Message" message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //TODO:处理界面跳转
    LOG(@"收到本地推送：%@,%@",notification.alertBody,notification.userInfo.description);
    //NSDictionary *notificationDic = notification.userInfo;
    //FIXME:这里需要弹出对话框进行提醒，目前默认同意
    /*
    if ([[notificationDic objectForKey:@"noticeType"] isEqualToString:@"ADD_FRIEND_REQUEST"]) {
        [[[XMPPWorker sharedInstance] xmppRoster] acceptPresenceSubscriptionRequestFrom:[notificationDic objectForKey:@"userID"] withSelfNickName:[notificationDic objectForKey:@"selfNickName"] userName:[notificationDic objectForKey:@"userNickName"] andAddToRoster:YES];
    }
     */
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
#if TARGET_IPHONE_SIMULATOR
    LOG(@"info:%@&%@",@"The iPhone simulator does not process background network traffic. ",@"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
    if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
    {
        [application setKeepAliveTimeout:600 handler:^{
            
            LOG(@"KeepAliveHandler");
            // Do other keep alive stuff here.
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self stopEngine];
}

//内存紧张就及时回收内存
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    /*
    // 清除内存中的图片缓存
    SDWebImageManager *sdWebImageManager = [SDWebImageManager sharedManager];
    [sdWebImageManager cancelAll];
    [sdWebImageManager.imageCache clearMemory];
     */
}

/****************************************************初始化数据***********************************************************/

//初始化数据
- (void)initData
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self currentViewController];
    [self.window makeKeyAndVisible];
}

//初始化网络检查工具
-(void)startCheckNetwork
{
    NetStatusManager *netStatusManager = [NetStatusManager sharedInstance];
    [netStatusManager setDelegate:self];
    self.networkStatus = ([netStatusManager getInitNetworkStatus] ? NetworkStatusDefaultType:NetworkStatusNoInternetType);
}

//读取.plist文件
-(void)startReadPlistFiles
{
    GLOBAL_GCD(^{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SystemNetAPI" ofType:@"plist"];
        NSDictionary *systemAPIDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        [[SystemConfig sharedInstance] SetBaseURLStr:[systemAPIDic objectForKey:@"QCD_BASE_URL"]];
        [[SystemConfig sharedInstance] SetMessageURLStr:[systemAPIDic objectForKey:@"QCD_REQUEST_MSG_URL"]];
        [[SystemConfig sharedInstance] SetCheckSumSecret:[systemAPIDic objectForKey:@"CHECKSUM_SECRET"]];
        [[UserConfig sharedInstance] SetAutoLogin:YES];
    });
    
}

//开启网络服务
- (void)startEngine
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}
//关闭服务
- (void)stopEngine
{

}
/*********************************************************************************************************************/

/**
 *  获取启动时系统的根Viewcontroller
 *
 *  @return viewcontroller
 */
-(id)currentViewController
{
    if ([[UserConfig sharedInstance] GetAutoLogin]) {
        //自动登录并跳转到主页面
        MainTabBarController *mainViewController = [self instantiateInitialViewControllerWithStroryboardName:@"Main"];
        //[mainViewController setNeedLogin:YES];
        return mainViewController;
    }
    //跳转到登录页面
    return [self instantiateInitialViewControllerWithStroryboardName:@"login_register"];
}
/**
 *  根据storyboard获取开始的viewcontroller对象
 *
 *  @param storyboardName storyboard名称
 *
 *  @return storyboard开始的viewcontroller对象
 */
-(id)instantiateInitialViewControllerWithStroryboardName:(NSString *)storyboardName
{
    return [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateInitialViewController];
}

//register remote push notification
-(void)registerRemoteNotificationWith:(UIApplication *)application
{
    // Register for push notifications

#ifdef SUPPORT_IOS8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else
#endif
    {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }

}

-(void)setApplicationRootViewController:(UIViewController *)viewController
{
    [self.window setRootViewController:viewController];
}

#pragma mark CheckNetStatusDelegate Methods
//运行断网处理
-(void)DisconnectNetWork
{
    LOG(@"Disconnect with the network");
    self.networkStatus = NetworkStatusNoInternetType;
}
//有网时处理
-(void)ConnectNetWork
{
    LOG(@"Connect with the network");
    self.networkStatus = NetworkStatusDefaultType;
}
//没有网络时
-(void)NoNetWork
{
    LOG(@"NO_Network at this time");
    self.networkStatus = NetworkStatusNoInternetType;
}

#pragma mark - Private methods


/*
//CoreData manager
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.qingchund.app.QingChunApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QingChunApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"QingChunApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
*/
@end
