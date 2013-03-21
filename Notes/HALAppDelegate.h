//
//  HALAppDelegate.h
//  Notes
//
//  Created by Hanssen Li on 3/1/13.
//  Copyright (c) 2013 Hanssen Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "HALMainViewController.h"


@interface HALAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
