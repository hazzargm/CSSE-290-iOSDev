//
//  Driver.h
//  GasStats
//
//  Created by CSSE Department on 2/7/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car, GasBill, GasStat;

@interface Driver : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * joinDate;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) GasStat *logs;
@property (nonatomic, retain) Car *owns;
@property (nonatomic, retain) GasBill *views;

@end
