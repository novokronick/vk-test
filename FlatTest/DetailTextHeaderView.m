//
//  DetailTextHeaderView.m
//  FlatTest
//
//  Created by KroNIck on 21.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "DetailTextHeaderView.h"

#define DETAIL_HEADER_MIN_WIDTH 20
#define DETAIL_HEADER_MIN_HEIGHT 20

@implementation DetailTextHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGFloat)heightForText:(NSString *)string collectionWidth:(CGFloat)collectionWidth
{
    static UIFont *font;
    
    if (!font) {
        font = [UIFont systemFontOfSize:14.0];
    }
    
    CGSize bigSize = CGSizeMake(collectionWidth - DETAIL_HEADER_MIN_WIDTH, CGFLOAT_MAX);
    CGFloat height;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    CGRect frame = [string boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    height = frame.size.height;
#else
    CGSize size = [string sizeWithFont:font constrainedToSize:bigSize];
    height = size.height;
#endif
    
    return height + DETAIL_HEADER_MIN_HEIGHT + 3;
}

- (void)setPostText:(NSString *)postText
{
    _postText = postText;
    self.textLabel.text = postText;
}


@end
