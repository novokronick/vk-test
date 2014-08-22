//
//  DetailController.m
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "DetailController.h"
#import "ImageCollectionCell.h"
#import "DetailTextHeaderView.h"
#import "DetailCollectionLayout.h"

#define IMAGE_CELL @"ImageCell"
#define TEXT_HEADER @"TextHeader"

@interface DetailController ()
{
    NSArray *imageArray;
}
@end

@implementation DetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.postItem.theUser.name;
    imageArray = [self.postItem sortedImagesArray];
    
    //self.collectionView.collectionViewLayout = [[DetailCollectionLayout alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageItem *imageItem = [imageArray objectAtIndex:indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IMAGE_CELL forIndexPath:indexPath];
 
    if ([cell isKindOfClass:[ImageCollectionCell class]]) {
        ImageCollectionCell *imageCell = (ImageCollectionCell *)cell;
        
        [imageCell setImageLink:imageItem.linkSmall];
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        DetailTextHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TEXT_HEADER forIndexPath:indexPath];
        
        NSString *postText = self.postItem.text;
        
        [headerView setPostText:postText];
        
        reusableView = headerView;
    }
    
    return reusableView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSString *text = self.postItem.text;
    
    CGFloat collectionWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat heigth = [DetailTextHeaderView heightForText:text collectionWidth:collectionWidth];
    
    return CGSizeMake(collectionWidth, heigth);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
