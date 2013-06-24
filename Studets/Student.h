//
//  Student.h
//  Studets
//
//  Created by Michael Redko on 5/9/13.
//  Copyright (c) 2013 Michael Redko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * hobby;

@end
