//
//  HALDetailViewController.m
//  Notes
//
//  Created by Hanssen Li on 3/1/13.
//  Copyright (c) 2013 Hanssen Li. All rights reserved.
//

#import "HALDetailViewController.h"

@interface HALDetailViewController ()
@end


@implementation HALDetailViewController
@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem :(NSInteger)index
{
    if (self.detailItem != newDetailItem) {
        
        _detailItem = newDetailItem;
        
        path = [NSString stringWithFormat:@"%d", index];
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    
    // Update the user interface for the detail item.
    if (![self.titleView.text isEqualToString:self.detailItem[@"title"]]) {
        
        self.titleView.text = self.detailItem[@"title"];
    }
    
    textView.text = self.detailItem[@"description"];
    
    CLLocation *loc = self.detailItem[@"location"];
    
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = loc.coordinate;
    pin.title = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    pin.subtitle = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
    [self.mapView addAnnotation:pin];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(pin.coordinate, span);
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(49, -123);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200)];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];

}

// In some view controller
- (void) viewDidDisappear:(BOOL)animated
{
    if (self.navigationController == nil) {
        // popped from navigation stack.
        // do something...
        
        NSDictionary *note = @{@"title": self.titleView.text, @"description": textView.text, @"location": self.detailItem[@"location"], @"index": path};
        // Post a notification
        [[NSNotificationCenter defaultCenter]postNotificationName:@"saveNote" object:self userInfo:note];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureView];
    
}

- (void) viewDidAppear:(BOOL)animated {
    CLLocation *loc = self.detailItem[@"location"];
    
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = loc.coordinate;
    pin.title = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    pin.subtitle = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
    [self.mapView addAnnotation:pin];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.0, 0.03);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(pin.coordinate, span);
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];


}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
