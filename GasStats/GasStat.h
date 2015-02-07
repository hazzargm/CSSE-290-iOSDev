//
//  GasStat.h
//  GasStats
//
//  Created by CSSE Department on 2/7/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car, Driver, GasBill, TankRecords;

@interface GasStat : NSManagedObject

@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * gallons;
@property (nonatomic, retain) NSNumber * miles;
@property (nonatomic, retain) NSNumber * mpg;
@property (nonatomic, retain) NSNumber * car_id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) TankRecords *become;
@property (nonatomic, retain) GasBill *creates;
@property (nonatomic, retain) Car *describe;
@property (nonatomic, retain) Driver *recordedBy;

@end
