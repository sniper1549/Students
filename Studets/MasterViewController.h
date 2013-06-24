//
//  MasterViewController.h
//  Studets
//
//  Created by Michael Redko on 5/9/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

/*@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;*/
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnRefresh;

- (IBAction)btnRefreshPressed:(id)sender;

@end
