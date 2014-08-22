//
//  DataManager.m
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "DataManager.h"
#import <CoreData+MagicalRecord.h>
#import "TokenError.h"

#import "PostCell.h"

@implementation DataManager

+ (DataManager *)sharedInstance
{
    static DataManager *instance;
    static dispatch_once_t once_t;
    
    dispatch_once(&once_t, ^{
        instance = [[DataManager alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [VKSdk initialize];
        
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"FlatTest" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        
        [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"db_02"];
    }
    
    return self;
}

- (void)setVkToken:(NSString *)vkToken
{
    [[NSUserDefaults standardUserDefaults] setObject:vkToken forKey:VK_TOKEN_KEY];
}

- (NSString *)vkToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:VK_TOKEN_KEY];
}

- (NSNumber *)vkPostsOffset
{
    if (!_vkPostsOffset) {
        return @0;
    }
    
    return _vkPostsOffset;
}

- (NSUInteger)fetchLimit
{
    if (self.vkPostsOffset.intValue == 0) {
        return LOAD_COUNT.intValue;
    }
    
    return self.vkPostsOffset.intValue;
}

- (BOOL)shouldShowLoginVC
{    
    return (self.vkToken == nil);
}

- (void)loadNewPostsBlock:(void (^)(NSError *error))callback
{
    [self loadPostsOffset:@0 limit:LOAD_COUNT newFrom:nil block:callback];
}

- (void)loadEarlierPostsBlock:(void (^)(NSError *error))callback
{
    NSNumber *limit = LOAD_COUNT;
    NSNumber *curOffset = [SharedDataManager vkPostsOffset];
    
    if (curOffset.intValue == 0) {
        limit = [NSNumber numberWithInt:LOAD_COUNT.intValue * 2];
    }
    
    [self loadPostsOffset:self.vkPostsOffset limit:limit newFrom:self.vkPostsLoadFrom block:callback];
}

- (void)loadPostsOffset:(NSNumber *)offsetNum limit:(NSNumber *)limit newFrom:(NSString *)newFrom block:(void (^)(NSError *error))callback
{
    NSString *vkToken = self.vkToken;
    
    if (!vkToken) {
        TokenError *error = [[TokenError alloc] init];
        callback(error);
        return;
    }
    
    NSDictionary *paramsDict = @{@"filters": @"post",
                                        @"access_token": vkToken,
                                        @"count" : limit};
    
    NSMutableDictionary *mutableParamsDict = [[NSMutableDictionary alloc] initWithDictionary:paramsDict];
    
    [mutableParamsDict setObject:offsetNum forKey:@"offset"];
    
    if (newFrom) {
        [mutableParamsDict setObject:newFrom forKey:@"from"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"https://api.vk.com/method/newsfeed.get" parameters:mutableParamsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"request: %@", operation.request);
        NSLog(@"get: %@", responseObject);
        
        [self fetchPosts:(NSDictionary *)responseObject block:callback];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get failure: %@", error);
        callback(error);
    }];
}

- (void)fetchPosts:(NSDictionary *)responseDict block:(void (^)(NSError *error))callback
{
    NSDictionary *typesDict = [responseDict objectForKey:@"response"];
    NSLog(@"keys: %@", [typesDict allKeys]);
    
    NSNumber *newOffset = [typesDict objectForKey:@"new_offset"];
    NSString *newFrom = [typesDict objectForKey:@"new_from"];
    
    self.vkPostsOffset = newOffset;
    self.vkPostsLoadFrom = newFrom;
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSArray *profilesArray = [typesDict objectForKey:@"profiles"];
    for (NSDictionary *profile in profilesArray) {
        [UserItem addUserWithData:profile inContext:context];
    }
    
    NSArray *groupsArray = [typesDict objectForKey:@"groups"];
    for (NSDictionary *group in groupsArray) {
        [UserItem addGroupWithData:group inContext:context];
    }
    
    NSArray *itemsArray = [typesDict objectForKey:@"items"];
    for (NSDictionary *item in itemsArray) {
        [PostItem addPostWithData:item inContext:context];
    }
    
    NSError *error;
    [context MR_saveOnlySelfAndWait];
    
    callback(error);
}

- (void)removeStoredData
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
    
    [ImageItem MR_deleteAllMatchingPredicate:nil inContext:context];
    [PostItem MR_deleteAllMatchingPredicate:nil inContext:context];
    [UserItem MR_deleteAllMatchingPredicate:nil inContext:context];
    
    [context MR_saveOnlySelfAndWait];
    
    [SharedDataManager setVkPostsOffset:nil];
    [SharedDataManager setVkPostsLoadFrom:nil];
}

@end
