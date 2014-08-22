//
//  PostItem+Data.m
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "PostItem+Data.h"
#import "UserItem+Data.h"
#import "ImageItem+Data.h"

@implementation PostItem (Data)

+ (PostItem *)addPostWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context
{
    NSString *type = [data objectForKey:@"type"];
    NSString *text = [data objectForKey:@"text"];
    NSNumber *sourceId = [data objectForKey:@"source_id"];
    NSNumber *postId = [data objectForKey:@"post_id"];
    NSNumber *dateNum = [data objectForKey:@"date"];
    
    //NSDictionary *attachment = [data objectForKey:@"attachment"];
    //NSDictionary *photo = [attachment objectForKey:@"photo"];
    NSArray *attachArray = [data objectForKey:@"attachments"];
    
    PostItem *post;
    
    if ([type isEqualToString:@"post"] && postId) {
        post = [PostItem postById:postId inContext:context];
        
        if (!post) {
            post = [PostItem MR_createInContext:context];
            post.postId = postId;
        }
        
        post.text = text;
        post.date = [NSDate dateWithTimeIntervalSince1970:dateNum.intValue];
        
        UserItem *postUser = [UserItem userById:sourceId inContext:context];
        
        post.theUser = postUser;
    }
    
    for (NSDictionary *attachment in attachArray) {
        NSDictionary *photo = [attachment objectForKey:@"photo"];
        if (photo) {
            ImageItem *image = [ImageItem addImageWithData:photo inContext:context];
            if (image) {
                image.thePost = post;
            }
        }
    }
    
    return post;
}

+ (PostItem *)postById:(NSNumber *)postId inContext:(NSManagedObjectContext *)context
{
    PostItem *post;
    
    post = [[PostItem MR_findByAttribute:@"postId" withValue:postId inContext:context] lastObject];
    
    return post;
}

- (NSArray *)sortedImagesArray
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.thePost = %@", self];
    NSArray *imageArray = [ImageItem MR_findAllSortedBy:@"date" ascending:YES withPredicate:predicate];
    
    return imageArray;
}

@end
