//
//  HALMainViewController.h
//  Notes
//
//  Created by Hanssen Li on 3/1/13.
//  Copyright (c) 2013 Hanssen Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Note.h"

@interface HALMainViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *tableData;

@end
