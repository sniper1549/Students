//
//  DetailViewController.h
//  Students
//
//  Created by Michael Redko on 7/24/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Students.h"

@interface DetailViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *teName;
@property (retain, nonatomic) IBOutlet UITextField *teHobby;

@property (strong, nonatomic) Students *selectedItem;

@end
