//
//  DetailViewController.m
//  Studets
//
//  Created by Michael Redko on 5/9/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()
- (void)configureView;
- (void)initPickerSources;

@property (nonatomic,retain) NSMutableArray *ageList;

@end

@implementation DetailViewController

@synthesize ageList;

- (void)dealloc
{    
    self.curentStudent = nil;
    [_teName release];
    [_teHobby release];
    [_agePicker release];
    [super dealloc];
}

- (void) initPickerSources
{
    self.ageList = [[NSMutableArray alloc] init];
    
    for(int i=0;i<=120;i++)
    {
        NSNumber *anumber = [NSNumber numberWithInteger:i];
        [self.ageList addObject:anumber];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.teName.text = self.curentStudent.name;
    self.teHobby.text = self.curentStudent.hobby;
    
   [self.agePicker selectRow:[self.curentStudent.age integerValue] inComponent:0 animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initPickerSources];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark save button

- (IBAction) save:(id)sender
{
     NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
     NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
     NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
     
     // If appropriate, configure the new managed object.
     // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
     [newManagedObject setValue:self.teName.text forKey:@"name"];
     [newManagedObject setValue:self.teHobby.text forKey:@"hobby"];
    
     NSNumber *anumber = [NSNumber numberWithInteger:[self.agePicker selectedRowInComponent:0]];
     [newManagedObject setValue:anumber forKey:@"age"];
     
     // Save the context.
     NSError *error = nil;
     if (![context save:&error]) {
     // Replace this implementation with code to handle the error appropriately.
     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
     abort();
     }   
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Picker Datasource Protocol

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.ageList.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.ageList objectAtIndex:row] stringValue];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}


							
@end
