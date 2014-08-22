//
//  PostCell.m
//  FlatTest
//
//  Created by KroNIck on 21.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "PostCell.h"
#import <UIImageView+WebCache.h>

#define POST_CELL_MIN_WIDTH 20
#define POST_CELL_MIN_HEIGHT 100

@implementation PostCell

- (void)awakeFromNib
{
    // Initialization code
        
}

+ (CGFloat)textHeightForPostItem:(PostItem *)postItem tableWidth:(CGFloat)tableWidth
{
    const CGFloat maxTextHeight = 62.0;
    
    static NSMutableDictionary *cacheDict;
    static UIFont *font;
    
    if (!font) {
        font = [UIFont systemFontOfSize:14.0];
    }
    
    if (!cacheDict) {
        cacheDict = [[NSMutableDictionary alloc] init];
        font = [UIFont systemFontOfSize:14.0];
    }
    
    NSString *string = postItem.text;
    
    NSNumber *heightNum = [cacheDict objectForKey:string];
    
    if (!heightNum) {
        CGFloat height;
        CGSize bigSize = CGSizeMake(tableWidth - POST_CELL_MIN_WIDTH, CGFLOAT_MAX);
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        CGRect frame = [string boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        
        height = frame.size.height;
#else
        CGSize size = [string sizeWithFont:font constrainedToSize:bigSize];
        height = size.height;
#endif
        height = MIN(height, maxTextHeight);
        
        heightNum = [NSNumber numberWithFloat:height];
        [cacheDict setObject:heightNum forKey:string];
    }
    
    return heightNum.floatValue;
}

+ (CGFloat)heightForPostItem:(PostItem *)postItem tableWidth:(CGFloat)tableWidth
{
    const CGFloat imageHeight = 95;
    
    CGFloat height = [PostCell textHeightForPostItem:postItem tableWidth:tableWidth] + POST_CELL_MIN_HEIGHT;
    
    if (postItem.images.count > 0) {
        height += imageHeight;
    }
    
    return height;
}

- (void)setPostItem:(PostItem *)postItem tableWidth:(CGFloat)tableWidth
{
    _postItem = postItem;
    self.nameLabel.text = postItem.theUser.name;
    self.stringLabel.text = postItem.text;
    
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:postItem.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    
    /*
    CGRect textFrame = self.textLabel.frame;
    textFrame.size.height = [PostCell textHeightForPostItem:postItem tableWidth:tableWidth];
    
    self.textLabel.frame = textFrame;
    */
    
    NSString *userImageLink = postItem.theUser.photoLink;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:userImageLink]];
    
    NSString *firstImageLink;
    NSString *secondImageLink;
    
    NSArray *imagesArray = [postItem sortedImagesArray];
    
    if (imagesArray.count > 0) {
        ImageItem *image = [imagesArray objectAtIndex:0];
        firstImageLink = image.linkSmall;
    }
    
    if (imagesArray.count > 1) {
        ImageItem *image = [imagesArray objectAtIndex:1];
        secondImageLink = image.linkSmall;
    }
    
    [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:firstImageLink]];
    [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:secondImageLink]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
