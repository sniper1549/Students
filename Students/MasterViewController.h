//
//  MasterViewController.h
//  Students
//
//  Created by Michael Redko on 7/24/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (retain, nonatomic) DetailViewController *detailViewController;

@end
