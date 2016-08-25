//
//  TweetsViewController.h
//  Twitter_Gong
//
//  Created by gongzhen on 8/23/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TimelineType) {
    TimelineTypeHome = 0,
    TimelineTypeUser = 1,
    TimelineTypeMentions = 2
};

@class TweetsViewController;

// protocol:TweetsViewControllerDelegate
@protocol TweetsViewControllerDelegate <NSObject>

- (void)menuButtonTappedByTweetsViewController:(TweetsViewController *)tvc;

@end

@interface TweetsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// assign doesn't perform any kind of memory management call.
// It is default behavior for primitive data types.
// You shouldn't ever use this in modern applications.
@property (assign, nonatomic) TimelineType timelineType;
@property NSMutableDictionary *estimatedRowHeightCache;
@property (weak, nonatomic) id<TweetsViewControllerDelegate> delegate;

@end
