//
//  TweetsViewController.m
//  Twitter_Gong
//
//  Created by gongzhen on 8/23/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TimelineTweetCell.h"
#import <SVPullToRefresh.h>

@interface TweetsViewController ()

// public property
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSNumber *lowestID;

@end

@implementation TweetsViewController

#pragma mark - lazing loading
-(UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        
        // delegate
        tableView.delegate = self;
        tableView.dataSource = self;
                
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        _tableView = tableView;
    }
    return _tableView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark View methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set up tableView
    self.tweets = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor greenColor];
    // Set up NavigationBar
    switch (self.timelineType) {
        case TimelineTypeHome:
            self.title = @"Home";
            break;
        case TimelineTypeUser:
            self.title = @"User Timeline";
            break;
        case TimelineTypeMentions:
            self.title = @"Mentions";
            break;
        default:
            break;
    }
    
    // registerNib
//    [self.tableView registerNib:[UINib nibWithNibName:@"TimelineTweetCell" bundle:nil] forCellReuseIdentifier:@"TimelineTweetCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"TimelineTweetCellRetweeted" bundle:nil] forCellReuseIdentifier:@"TimelineTweetCellRetweeted"];
    // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    
    [self.view addSubview:self.tableView];
    [self configureTableViewPosition];
    [self getTimelineTweets];

}

-(void)configureTableViewPosition {
    // contentView top
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *tableViewTop = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewTop];
    // contentView Bottom
    NSLayoutConstraint *tableViewBottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewBottom];
    // contentView Trailing
    NSLayoutConstraint *tableViewTrailing = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewTrailing];
    // contentView Leading
    NSLayoutConstraint *tableViewLeading = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewLeading];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews
{
    
}

#pragma mark Actions

- (IBAction)onLogout:(id)sender
{
    // todo logout
}

#pragma mark - Twitter API methods

-(void)getTimelineTweets {
    // TimelineTypeHome
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (error) {
            NSLog(@"Error getting timeline: %@", error);
            return;
        }
        self.tweets = [NSMutableArray arrayWithArray:tweets];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView.pullToRefreshView stopAnimating];
    }];

}

#pragma mark Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return self.tweets.count;
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TimelineTweetCell *cell;
//    if ([(Tweet *)self.tweets[indexPath.row] retweetedTweet]) {
//        cell = [self.tableView dequeueReusableCellWithIdentifier:@"TimelineTweetCellRetweeted"];
//    } else {
//        cell = [self.tableView dequeueReusableCellWithIdentifier:@"TimelineTweetCell"];
//    }
//    cell.tweet = self.tweets[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    // Configure Cell
    [cell.textLabel setText:[NSString stringWithFormat:@"Row %li in Section %li", [indexPath row], (long)[indexPath section]]];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
