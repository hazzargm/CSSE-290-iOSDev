//
//  GasBill.h
//  GasStats
//
//  Created by CSSE Department on 2/3/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car, Driver, GasStat;

@interface GasBill : NSManagedObject

@property (nonatomic, retain) NSNumber * expense;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) GasStat *isA;
@property (nonatomic, retain) Driver *informs;
@property (nonatomic, retain) Car *causedBy;

@end
