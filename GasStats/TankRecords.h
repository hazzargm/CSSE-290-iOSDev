//
//  TankRecords.h
//  GasStats
//
//  Created by CSSE Department on 2/3/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car, GasStat;

@interface TankRecords : NSManagedObject

@property (nonatomic, retain) NSNumber * best;
@property (nonatomic, retain) NSNumber * last;
@property (nonatomic, retain) NSNumber * average;
@property (nonatomic, retain) Car *showcase;
@property (nonatomic, retain) GasStat *highlight;

@end
