//
//  Car.h
//  GasStats
//
//  Created by CSSE Department on 2/3/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Driver;

@interface Car : NSManagedObject

@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSNumber * shared;
@property (nonatomic, retain) Driver *has;
@property (nonatomic, retain) NSManagedObject *accumulates;
@property (nonatomic, retain) NSManagedObject *records;
@property (nonatomic, retain) NSManagedObject *breaks;
@property (nonatomic, retain) NSManagedObject *knows;

@end
