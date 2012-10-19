//
//  Event.h
//  CoreGithub
//
//  Created by Dave Henke on 10/19/12.
//  Copyright (c) 2012 Solstice Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * identifier;

@end
