//
//  TwitterService.h
//  CoreTwitter
//
//  Created by Dave Henke on 10/19/12.
//  Copyright (c) 2012 Solstice Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GitHubService : NSObject

+ (GitHubService*)shared;

- (void)eventsWithCompletion:(void (^)(NSArray *events))success andErrors:(void(^)(NSError *err))errors;
- (void)storedEventsWithCompletion:(void (^)(NSArray *events))success andErrors:(void(^)(NSError *err))errors;


@end
