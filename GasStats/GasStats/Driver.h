//
//  Driver.h
//  GasStats
//
//  Created by CSSE Department on 2/3/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Driver : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * joinDate;
@property (nonatomic, retain) NSManagedObject *owns;
@property (nonatomic, retain) NSManagedObject *logs;
@property (nonatomic, retain) NSManagedObject *views;

@end
