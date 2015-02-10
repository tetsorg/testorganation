//
//  AppDelegate.h
//  装之助
//
//  Created by caiyc on 14/11/4.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BMapKit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
{
    BMKMapManager *mapManager;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

