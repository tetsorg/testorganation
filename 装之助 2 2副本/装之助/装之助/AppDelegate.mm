//
//  AppDelegate.m
//  装之助
//
//  Created by caiyc on 14/11/4.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "AppDelegate.h"
#import "RootVc.h"
#import "NSString+SBJSON.h"
#import "SBJSON.h"
#import "Reachability.h"
#import "MyDbHandel.h"
@interface AppDelegate ()
{
    Reachability *hostReach;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   // [self handeldata];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        // 1
//                });
//       	    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
//        [self handeldata];
//    });

    DLog(@"%@",NSHomeDirectory());
   
    
   
    if(ISIPHONE6)DLog(@"iphone6");
    else if (ISIPHONE5)DLog(@"ipone5");
    else DLog(@"iphone4");

    [self startMapManager];
    if(![FuncPublic GetDefaultInfo:@"uid"])
    {
      [ FuncPublic SaveDefaultInfo:@"1234" Key:@"uid"];
    }
    if(![FuncPublic GetDefaultInfo:@"uname"])
    {
        [ FuncPublic SaveDefaultInfo:@"caiyc" Key:@"uname"];
    }
    if(![FuncPublic GetDefaultInfo:@"cityName"])
    {
    [FuncPublic SaveDefaultInfo:@"南昌" Key:@"cityName"];
    }
    if(![FuncPublic GetDefaultInfo:@"cid"])
    {
        [FuncPublic SaveDefaultInfo:@"360100" Key:@"cid"];
    }
    if(![FuncPublic GetDefaultInfo:@"role"])
    {
        [FuncPublic SaveDefaultInfo:@"工人" Key:@"role"];
    }
    
    // 设置网络状态变化时的通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)name:@"kNetworkReachabilityChangedNotification" object:nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [hostReach startNotifier];
    
    RootVc *rootVc = [[RootVc alloc]init];
    UINavigationController *rootNav= [[UINavigationController alloc]initWithRootViewController:rootVc];
    rootNav.navigationBarHidden  = YES;
    self.window.rootViewController = rootNav;
    
    // Override point for customization after application launch.
    return YES;
}
-(void) handeldata
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"jsondata" ofType:@"txt"];
    
    NSString *cityString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *cityDic = [cityString JSONValue];
    
    NSArray *cityarr = [cityDic objectForKey:@"data"];
    
    NSFileManager *fiels = [NSFileManager defaultManager];
    NSString *paths = [NSHomeDirectory()stringByAppendingString:@"/Documents/Citys.sqlite"];
    
    BOOL exsits = [fiels fileExistsAtPath:paths isDirectory:nil];
//    if(exsits)
//    {
//        dispatch_async(dispatch_queue_create("dsd", nil), ^{
//            
//           // [self performSelector:@selector(getCityData) withObject:nil];
//            
//        });
//        
//        //   [self getCityData];
//      //  return;
//    }else
//    {
        [[MyDbHandel defaultDBManager]openDb:@"Citys.sqlite"];
        
        NSString *sql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id INTEGER,pid INTEGER,name TEXT, pyjx TEXT,py TEXT)",NAME];
        
        [[MyDbHandel defaultDBManager]creatTab:sql];
    
   // [[MyDbHandel defaultDBManager]openDb:@"Citys.sqlite"];
    
        for(NSDictionary *dic in cityarr)
        {
          //  NSLog(@"数组数据;;%@",dic);
            
            NSMutableDictionary *dictions = [NSMutableDictionary dictionary];
            
            [dictions setObject:[dic objectForKey:@"id"] forKey:@"id"];
            [dictions setObject:[dic objectForKey:@"pid"] forKey:@"pid"];
            [dictions setObject:[dic objectForKey:@"name"] forKey:@"name"];
            [dictions setObject:[dic objectForKey:@"piny"] forKey:@"py"];
            [dictions setObject:[dic objectForKey:@"pinyjx"] forKey:@"pyjx"];
            [[MyDbHandel defaultDBManager]insertdata:dictions];
           // [[MyDbHandel defaultDBManager]insertdata:dic];
        }
//        for(NSString *str in [dic allKeys])
//        {
//            
//            NSArray *arr = [dic objectForKey:str];
//            
//            NSMutableDictionary *dicto = [NSMutableDictionary dictionary];
//            
//            for(NSDictionary *dicc in arr)
//            {
//                [dicto setObject:[dicc objectForKey:@"key"] forKey:@"first"];
//                
//                [dicto setObject:[dicc objectForKey:@"name"] forKey:@"name"];
//                
//                NSString *piny = [self phonetic:[dicc objectForKey:@"name"]];
//                
//                [dicto setObject:piny forKey:@"piny"];
//                
//                [[MyDbHandel defaultDBManager]insertdata:dicto];
//                
//            }
//        }
   // }
    
}
- (void)startMapManager {
    
    // 初始化百度地图的启动
    mapManager = [[BMKMapManager alloc] init];
    if (![mapManager start:@"2UQqxLfFIHqGlWWck1UcBjQu" generalDelegate:self]) {
        NSLog(@"Manager start failed!");
    };
    //[mapManager release]; // 不能释放，所以需要全局
}
#pragma mark -
#pragma mark - BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError {
    
    if (0 == iError) {
        NSLog(@"联网成功");
        
    } else{
        NSLog(@"onGetNetworkState %d", iError);
    }
    
}

- (void)onGetPermissionState:(int)iError {
    
    if (0 == iError) {
        NSLog(@"授权成功");
        
    } else {
        NSLog(@"onGetPermissionState %d", iError);
    }
}

-(void)reachabilityChanged:(NSNotification *)note
{
    
    DLog(@"network changed.......");
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    //  self.isReachable = YES;
    if(status == NotReachable)
    {
        [WToast showWithText:@"请检查网络连接"];
    }
    else if(status==ReachableViaWWAN)
    {
        [WToast showWithText:@"已切换至3G网络"];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "none.___" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"___" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"___.sqlite"];
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

@end
