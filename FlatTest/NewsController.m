//
//  NewsController.m
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "NewsController.h"
#import "LoginController.h"
#import "DataManager.h"
#import "PostCell.h"
#import "LoadMoreCell.h"
#import <CoreData+MagicalRecord.h>
#import "DetailController.h"
#import <UIScrollView+SVPullToRefresh.h>
#import <UIScrollView+SVInfiniteScrolling.h>

#define DETAIL_SEGUE @"ToDetailSegue"
#define POST_CELL_ID @"PostCell"
#define LOAD_MORE_CELL_ID @"LoadMoreCell"

@interface NewsController ()
{
    NSFetchedResultsController *fetchedController;
    NSFetchRequest *request;
    BOOL isFirstRun;
}
@end

@implementation NewsController

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

    // top refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // bottom load more
    __weak NewsController *weakSelf = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SharedDataManager loadEarlierPostsBlock:^(NSError *error) {
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                [weakSelf updateTable];
            }];
        });
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PostCell" bundle:nil] forCellReuseIdentifier:POST_CELL_ID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LoadMoreCell" bundle:nil] forCellReuseIdentifier:LOAD_MORE_CELL_ID];
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"PostItem"];
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    
    [request setSortDescriptors:@[sortByDate]];
    
    [self updateTable];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    [SharedDataManager loadNewPostsBlock:^(NSError *error) {
        [self updateTable];
        [refreshControl endRefreshing];
    }];
}

- (void)updateTable
{
    NSError *error;
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    [request setFetchLimit:SharedDataManager.fetchLimit];
    fetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    [fetchedController performFetch:&error];
    
    [self.tableView reloadData];
    
    if (error) {
        NSLog(@"post fetch error: %@", error);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([SharedDataManager shouldShowLoginVC] && !isFirstRun) {
        //        LoginController *loginVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"];
        //
        //        [self.navigationController presentViewController:loginVC animated:YES completion:nil];
        [self performSegueWithIdentifier:@"ShowLoginVC" sender:nil];
    }
    
    isFirstRun = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (fetchedController.sections.count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedController.sections objectAtIndex:section];
        
        NSLog(@"section info: %u", [sectionInfo numberOfObjects]);
        
        return [sectionInfo numberOfObjects];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:POST_CELL_ID];
    
    PostItem *postItem = [fetchedController objectAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[PostCell class]]) {
        PostCell *postCell = (PostCell *)cell;
        [postCell setPostItem:postItem tableWidth:CGRectGetWidth(tableView.bounds)];
    }    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostItem *postItem = [fetchedController objectAtIndexPath:indexPath];
    
    CGFloat height = [PostCell heightForPostItem:postItem tableWidth:CGRectGetWidth(tableView.bounds)];
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostItem *selectedPost = [fetchedController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:DETAIL_SEGUE sender:selectedPost];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:DETAIL_SEGUE]) {
        if ([sender isKindOfClass:[PostItem class]]) {
            PostItem *selectedPost = (PostItem *)sender;
            
            if ([segue.destinationViewController isKindOfClass:[DetailController class]]) {
                DetailController *detailVC = (DetailController *)segue.destinationViewController;
                
                detailVC.postItem = selectedPost;
            }
        }
    }
}

- (IBAction)accountButtonTap:(id)sender
{
    [self performSegueWithIdentifier:@"ShowLoginVC" sender:nil];
}

@end
