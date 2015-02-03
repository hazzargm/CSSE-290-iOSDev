//
//  EPAData.h
//  GasStats
//
//  Created by CSSE Department on 2/3/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface EPAData : NSManagedObject

@property (nonatomic, retain) NSNumber * mpgCity;
@property (nonatomic, retain) NSNumber * mpgHighway;
@property (nonatomic, retain) NSNumber * mpgCombined;
@property (nonatomic, retain) Car *depicts;

@end
