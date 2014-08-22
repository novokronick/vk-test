//
//  DataManager.h
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <VKSdk.h>

#import "UserItem+Data.h"
#import "PostItem+Data.h"
#import "ImageItem+Data.h"

#define LOAD_COUNT @30

@interface DataManager : NSObject

@property (nonatomic, strong) NSString *vkToken;
@property (nonatomic, strong) NSNumber *vkPostsOffset;
@property (nonatomic, strong) NSString *vkPostsLoadFrom;


+ (DataManager *)sharedInstance;

- (BOOL)shouldShowLoginVC;
- (void)loadNewPostsBlock:(void (^)(NSError *error))callback;
- (void)loadEarlierPostsBlock:(void (^)(NSError *error))callback;
- (NSUInteger)fetchLimit;

- (void)removeStoredData;

@end
