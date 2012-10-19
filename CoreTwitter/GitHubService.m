//
//  TwitterService.m
//  CoreTwitter
//
//  Created by Dave Henke on 10/19/12.
//  Copyright (c) 2012 Solstice Mobile. All rights reserved.
//

#import "GitHubService.h"
#import "Event.h"

@interface GitHubService ()

@property (nonatomic, strong) RKObjectManager *objectManager;

@end

@implementation GitHubService

+ (GitHubService *)shared {
    static GitHubService *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[GitHubService alloc] init];
    });
    return shared;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.objectManager = [RKObjectManager managerWithBaseURLString:@"https://api.github.com"];
        self.objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"CoreGithub.sqlite"];
        [self.objectManager.mappingProvider setObjectMapping:[self objectMapping] forKeyPath:@""];
    }
    return self;
}

- (void)eventsWithCompletion:(void (^)(NSArray *))success andErrors:(void (^)(NSError *))errors {
    
}

- (void)storedEventsWithCompletion:(void (^)(NSArray *))success andErrors:(void (^)(NSError *))errors {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *context = self.objectManager.objectStore.managedObjectContextForCurrentThread;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = entityDescription;
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
        request.sortDescriptors = @[sortDescriptor];
        NSError *error;
        NSArray *array = [context executeFetchRequest:request error:&error];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (array == nil) {
                errors(error);
            } else {
                success(array);
            }
        });
    });
}

- (RKManagedObjectMapping *)objectMapping {
    RKManagedObjectMapping *eventMapping = [RKManagedObjectMapping mappingForClass:[Event class] inManagedObjectStore:self.objectManager.objectStore];
    [eventMapping mapKeyPath:@"created_at" toAttribute:@"created"];
    [eventMapping mapKeyPath:@"type" toAttribute:@"type"];
    [eventMapping mapKeyPath:@"actor.login" toAttribute:@"userName"];
    [eventMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    eventMapping.primaryKeyAttribute = @"identifier";
    return eventMapping;
}

@end
