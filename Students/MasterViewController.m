//
//  MasterViewController.m
//  Students
//
//  Created by Michael Redko on 7/24/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Students.h"
#import <CoreData/CoreData.h>

@interface MasterViewController ()

@property (nonatomic,retain)  NSArray *tableData;


- (void) initView;
- (void) initNavBar;
- (void) synchronizeWithServer;
- (void) createEntitiesByData: (NSData*) data;
- (void) showSynchronizeErrorMessage;
- (void) fillDataTable;

@end

@implementation MasterViewController

@synthesize tableData;
@synthesize detailViewController;

#define kServerUrl @"https://dl.dropboxusercontent.com/u/35263683/data.json"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Students list", @"Students list");
    }
    return self;
}

- (void)dealloc
{
    self.detailViewController = nil;
    self.tableData = nil;
    
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
    
    if([AppDelegate isLounchingFirstTime]){
        [self synchronizeWithServer];
    }else{
        [self fillDataTable];
    }
}

- (void) fillDataTable
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Students" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    self.tableData = [context executeFetchRequest:fetchRequest error:&error];

    
    [fetchRequest release];
}

- (void) initNavBar
{    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void) synchronizeWithServer
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerUrl]];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (data){
                [self createEntitiesByData:data];
                [self fillDataTable];
                
            }else {
                [self showSynchronizeErrorMessage];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [self.tableView reloadData];
            });
        }];
        [request release];
        
    });
}

- (void) createEntitiesByData: (NSData*) data
{
    NSMutableArray *objects = data == nil ? nil : [data objectFromJSONData];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    for(int i=0;i<[objects count];i++){
        
        Students *student = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Students" inManagedObjectContext:context];
        
        student.age = [[objects objectAtIndex:i] valueForKey:@"age"];
        student.name = [[objects objectAtIndex:i] valueForKey:@"name"];
        student.hobby = [[objects objectAtIndex:i] valueForKey:@"hobby"];
                        
        NSError *err;
        
        if( ! [context save:&err] ){
            NSLog(@"Cannot save data: %@", [err localizedDescription]);
        }                
    }
}

- (void) showSynchronizeErrorMessage
{
    UIAlertView* alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Synchronization error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)insertNewObject:(id)sender
{
   /* if (!tableData) {
        tableData = [[NSMutableArray alloc] init];
    }
    [tableData insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];*/
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
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
    
    Students *s = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = s.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }*/
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *nibName =IS_IPHONE_5 ? @"DetailViewController_iPhone5"
                        : @"DetailViewController";
    
           
    Students *student = tableData[indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[[DetailViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
	    }
	    self.detailViewController.selectedItem = student;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.selectedItem = student;
    }
}

@end
