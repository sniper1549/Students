//
//  DetailViewController.h
//  Studets
//
//  Created by Michael Redko on 5/9/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"


@interface DetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) Student *curentStudent;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) IBOutlet UITextField *teName;
@property (retain, nonatomic) IBOutlet UITextField *teHobby;
@property (retain, nonatomic) IBOutlet UIPickerView *agePicker;

- (IBAction)save:(id)sender;


@end
