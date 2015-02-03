//
//  GasStat.h
//  GasStats
//
//  Created by CSSE Department on 2/3/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car, Driver;

@interface GasStat : NSManagedObject

@property (nonatomic, retain) NSNumber * gallons;
@property (nonatomic, retain) NSNumber * miles;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSNumber * mpg;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Car *describe;
@property (nonatomic, retain) NSManagedObject *become;
@property (nonatomic, retain) NSManagedObject *creates;
@property (nonatomic, retain) Driver *recordedBy;

@end
