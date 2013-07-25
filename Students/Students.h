//
//  Students.h
//  Students
//
//  Created by Michael Redko on 7/24/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Students : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * hobby;
@property (nonatomic, retain) NSString * name;

@end
