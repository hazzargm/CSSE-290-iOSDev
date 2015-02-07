//
//  Car.h
//  GasStats
//
//  Created by CSSE Department on 2/7/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Driver, EPAData, GasBill, GasStat, TankRecords;

@interface Car : NSManagedObject

@property (nonatomic, retain) NSNumber * car_id;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * shared;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) GasBill *accumulates;
@property (nonatomic, retain) TankRecords *breaks;
@property (nonatomic, retain) Driver *has;
@property (nonatomic, retain) EPAData *knows;
@property (nonatomic, retain) GasStat *records;

@end
