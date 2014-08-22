//
//  PostCell.h
//  FlatTest
//
//  Created by KroNIck on 21.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostItem+Data.h"
#import "UserItem+Data.h"
#import "ImageItem+Data.h"

@interface PostCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *stringLabel;
@property (nonatomic, strong) IBOutlet UIImageView *userImageView;
@property (nonatomic, strong) IBOutlet UIImageView *firstImageView;
@property (nonatomic, strong) IBOutlet UIImageView *secondImageView;

@property (nonatomic, strong) PostItem *postItem;

+ (CGFloat)heightForPostItem:(PostItem *)postItem tableWidth:(CGFloat)tableWidth;
- (void)setPostItem:(PostItem *)postItem tableWidth:(CGFloat)tableWidth;

@end
