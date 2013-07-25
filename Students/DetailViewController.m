//
//  DetailViewController.m
//  Students
//
//  Created by Michael Redko on 7/24/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()


@end

@implementation DetailViewController

@synthesize teName;
@synthesize teHobby;


- (void)dealloc
{
    self.selectedItem = nil;

    self.teName = nil;
    self.teHobby = nil;
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
  /*  if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
    }*/
}

- (void)configureView
{
    if (self.selectedItem) {
        self.teName.text = self.selectedItem.name;
        self.teHobby.text = self.selectedItem.hobby;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
- (void)viewDidUnload {
    [self setTeName:nil];
    [self setTeHobby:nil];
    [super viewDidUnload];
}
@end
