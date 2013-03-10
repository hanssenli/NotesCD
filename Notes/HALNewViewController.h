//
//  HALNewViewController.h
//  Notes
//
//  Created by Hanssen Li on 3/1/13.
//  Copyright (c) 2013 Hanssen Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HALNewViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>
- (IBAction)saveNewNote:(id)sender;

@end
