//
//  DetailViewController.m
//  Students
//
//  Created by Michael Redko on 7/24/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property(nonatomic,strong) NSMutableArray *yearsArray;

@end

@implementation DetailViewController

@synthesize teName;
@synthesize teHobby;
@synthesize piYears;
@synthesize yearsArray;



- (void)dealloc
{
    self.selectedItem = nil;

    self.teName = nil;
    self.teHobby = nil;
    self.yearsArray = nil;
    self.piYears = nil;
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

        self.yearsArray = [[NSMutableArray alloc] init];
        for(int i=1;i<=100;i++){
            [self.yearsArray addObject:[NSNumber numberWithInt:i]];
        }
                    
        [self.piYears selectRow:[self.selectedItem.age integerValue]-1 inComponent:0 animated:NO];
        
        self.navigationItem.title = self.selectedItem.name;
        
        
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Back"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(OnClick_btnBack:)];
        self.navigationItem.leftBarButtonItem = btnBack;
        [btnBack release];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [self configureView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];   
    return self;
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.yearsArray.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{    
    return [[self.yearsArray objectAtIndex:row] stringValue];
}

-(IBAction)OnClick_btnBack:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setTeName:nil];
    [self setTeHobby:nil];
    [self setPiYears:nil];
    [super viewDidUnload];
}
- (IBAction)teDoneEditing:(id)sender {
    [sender resignFirstResponder];
}
@end
