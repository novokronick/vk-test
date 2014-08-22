//
//  DetailTextHeaderView.h
//  FlatTest
//
//  Created by KroNIck on 21.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTextHeaderView : UICollectionReusableView

//@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;

@property (nonatomic, strong) NSString *postText;

+ (CGFloat)heightForText:(NSString *)string collectionWidth:(CGFloat)collectionWidth;

@end
