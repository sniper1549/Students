//
//  MasterViewController.m
//  Students
//
//  Created by Michael Redko on 6/24/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface MasterViewController () {
    NSMutableArray *_objects;    
}

- (void) initView;
- (void) initNavBar;
- (void) synchronizeWithServer;

@end

@implementation MasterViewController

#define kServerUrl @"https://dl.dropboxusercontent.com/u/35263683/data.json"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Students", @"Students");
    }
    return self;
}
							
- (void)dealloc
{
    [_detailViewController release];
    [_objects release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void) initView
{
    [self initNavBar];
    
    [self synchronizeWithServer];
}

- (void) initNavBar
{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void) synchronizeWithServer
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerUrl]];
     
     [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     
     if (data)
     {
        self->_objects = data == nil ? nil : [data objectFromJSONData];
         
         AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         NSManagedObjectContext *context = [delegate managedObjectContext];
         
        for(int i=0;i<[self->_objects count];i++){
            NSLog(@"%@",[self->_objects objectAtIndex:i]);
            
            NSManagedObject *record = [NSEntityDescription insertNewObjectForEntityForName:@"Students" inManagedObjectContext:context];
            
            
            NSNumber *ageNum = [[self->_objects objectAtIndex:i] valueForKey:@"age"];
            NSString *name = [[self->_objects objectAtIndex:i] valueForKey:@"name"];
            NSString *hobby = [[self->_objects objectAtIndex:i] valueForKey:@"hobby"];
            
            [record setValue:ageNum forKey:@"age"];
            [record setValue:name forKey:@"name"];
            [record setValue:hobby forKey:@"hobby"];
            

            NSError *err;
            
            if( ! [context save:&err] ){
                NSLog(@"Cannot save data: %@", [err localizedDescription]);
            }

            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
     }
     else
     {
     
     }
    }];
    
    [request release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *object = _objects[indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil] autorelease];
	    }
	    self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
}

@end
