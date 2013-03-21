//
//  HALMainViewController.m
//  Notes
//
//  Created by Hanssen Li on 3/1/13.
//  Copyright (c) 2013 Hanssen Li. All rights reserved.
//

#import "HALMainViewController.h"
#import "HALDetailViewController.h"

@interface HALMainViewController ()
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSArray *tableDataBuffer;

@end

@implementation HALMainViewController
@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [[NSMutableArray alloc] init];
    [self reloadFromCoreData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Receive notification for new note
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewNote:) name:@"newNote" object:nil];
    
    // Receive notification for edited note
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNote:) name:@"saveNote" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadFromCoreData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Note" inManagedObjectContext: managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.tableDataBuffer = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Note *note in self.tableDataBuffer) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:(double)[note.latitude doubleValue] longitude:(double)[note.longitude doubleValue]];
        NSDictionary *eachNote = @{@"title": note.title, @"description": note.descrip, @"location": loc};
        [self.tableData addObject:eachNote];
    }
    
    [self.tableView reloadData];

}


- (void)addNewNote:(NSNotification *)note;
{
    NSDictionary *input = [note userInfo];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    Note *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    CLLocation *location = input[@"location"];
    
    newNote.title = input[@"title"];
    newNote.descrip = input[@"description"];
    
    newNote.latitude = (NSDecimalNumber *)
    [NSDecimalNumber numberWithDouble:location.coordinate.latitude];
    newNote.latitude = (NSDecimalNumber *)
                        [NSDecimalNumber numberWithDouble:location.coordinate.longitude];

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    
    [self.tableData addObject:input];
    
    [self.mainTableView reloadData];
}

- (NSArray *)getAllNotes
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Note" inManagedObjectContext:context];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (BOOL)deleteNote:(Note *)note
{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:note];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

- (BOOL)deleteAllNotes
{
    NSArray *allNotes = [self getAllNotes];
    for (Note *eachNote in allNotes) {
        if (![self deleteNote:eachNote]) {
            return NO;
        }
    }
    return YES;
}

- (void)refreshAllNotes
{
    NSManagedObjectContext *context = [self managedObjectContext];

    for (NSDictionary *input in self.tableData) {
        Note *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
        CLLocation *location = input[@"location"];
        
        newNote.title = input[@"title"];
        newNote.descrip = input[@"description"];
        
        newNote.latitude = (NSDecimalNumber *)
        [NSDecimalNumber numberWithDouble:location.coordinate.latitude];
        newNote.latitude = (NSDecimalNumber *)
        [NSDecimalNumber numberWithDouble:location.coordinate.longitude];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}


- (void)updateNote:(NSNotification *)note;
{
    NSDictionary *input = [note userInfo];
    
    NSDictionary *replacedNote = @{@"title": input[@"title"], @"description": input[@"description"], @"location": input[@"location"]};

    [self.tableData replaceObjectAtIndex: [input[@"index"] integerValue] withObject:replacedNote];
    
    [self deleteAllNotes];
    [self refreshAllNotes];
    
    
    [self.mainTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...

    cell.textLabel.text = self.tableData[indexPath.row][@"title"];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tableData removeObjectAtIndex:indexPath.row];
        
        [self deleteAllNotes];
        [self refreshAllNotes];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = self.tableData[indexPath.row];
        [[segue destinationViewController] setDetailItem:object :indexPath.row];
    }
}

@end
