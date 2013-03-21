//
//  HALNewViewController.m
//  Notes
//
//  Created by Hanssen Li on 3/1/13.
//  Copyright (c) 2013 Hanssen Li. All rights reserved.
//

#import "HALNewViewController.h"

@interface HALNewViewController ()
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation HALNewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.description = [[UITextView alloc]init];
    self.locationManager = [[CLLocationManager alloc] init];
    
    if([CLLocationManager locationServicesEnabled] == NO)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"Please enable your location services for this application" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)titleChanged:(id)sender {
    self.title = self.titleTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveNewNote:(id)sender {
    if (self.description != nil && self.title != nil) {
        NSDictionary *note = @{@"title": self.title, @"description": self.description.text, @"location": self.locationManager.location};
        // Post a notification
        [[NSNotificationCenter defaultCenter]postNotificationName:@"newNote" object:self userInfo:note];
    }
    // Terminate location services
    [self.locationManager stopUpdatingLocation];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
