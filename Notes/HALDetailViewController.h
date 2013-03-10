//
//  HALDetailViewController.h
//  Notes
//
//  Created by Hanssen Li on 3/1/13.
//  Copyright (c) 2013 Hanssen Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h> 

@interface HALDetailViewController : UIViewController <UINavigationBarDelegate, CLLocationManagerDelegate>
{
    NSString *path;
}

@property (weak, nonatomic) IBOutlet UITextField *titleView;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) id detailItem;


- (void)setDetailItem:(id)newDetailItem :(NSInteger)index;

@end
