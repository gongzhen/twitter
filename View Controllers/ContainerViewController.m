//
//  ContainerViewController.m
//  Twitter_GZ
//
//  Created by gongzhen on 8/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ContainerViewController.h"
#import "TweetsViewController.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "AccountsViewController.h"

@interface ContainerViewController()

// public properties
@property (nonatomic, strong) TweetsViewController *tweetsViewController;
@property (nonatomic, strong) TweetsViewController *mentionsTweetsViewController;
@property (nonatomic, strong) AccountsViewController *accountsViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (strong, nonatomic) UINavigationController *tweetsNavigationViewController;
@property (strong, nonatomic) UINavigationController *mentionsTweetsNavigationViewController;
@property (strong, nonatomic) UINavigationController *profileNavigationViewController;
@property (strong, nonatomic) UINavigationController *accountsNavigationViewController;
@property (strong, nonatomic) ProfileViewController *profileViewController;
@property (strong, nonatomic) UIView *intermediateView;
@property (nonatomic) BOOL menuDisplayed;
@property (strong, nonatomic) UIViewController *activeViewController;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation ContainerViewController

#pragma lazy loading
-(UIView *)contentView {
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 736)];
        _contentView = contentView;
    }
    return _contentView;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view: %f, %f", self.view.frame.size.width, self.view.frame.size.height); // view: 414.000000, 736.000000
    NSLog(@"navigationBar: %f, %f", self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height); // view: 414.000000, 736.000000
    NSLog(@"contentView: %f, %f", self.contentView.frame.size.width, self.contentView.frame.size.height); // contentView: 320.000000, 568.000000
    [self configureView];
    [self configureViewPositions];
    self.tweetsViewController = [[TweetsViewController alloc] init];
    self.tweetsNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.tweetsViewController];
    [self displayViewController:self.tweetsNavigationViewController];
}

-(void)configureView {
    [self.view addSubview:self.contentView];
}

-(void)configureViewPositions {
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect statusBarWindowRect = [self.view.window convertRect:statusBarFrame toWindow:nil];
    CGRect statusBarViewRect = [self.view convertRect:statusBarWindowRect toView:nil];
    
    // contentView top
    CGFloat topDistance = self.navigationController.navigationBar.frame.size.height + statusBarViewRect.size.height;
    NSLayoutConstraint *contentViewTop = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:topDistance];
    [self.view addConstraint:contentViewTop];
    // contentView Bottom
    NSLayoutConstraint *contentViewBottom = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:0];
    [self.view addConstraint:contentViewBottom];
    // contentView Trailing
    NSLayoutConstraint *contentViewTrailing = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraint:contentViewTrailing];
    // contentView Leading
    NSLayoutConstraint *contentViewLeading = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self.view addConstraint:contentViewLeading];
}

#pragma mark private methods.

- (void)displayViewController:(UIViewController *)viewController {
    [self displayViewController:viewController animated:NO hideCurrent:NO];
}

- (void)displayViewController:(UIViewController *)viewController animated:(BOOL)animated hideCurrent:(BOOL)hideCurrent {
    [self addChildViewController:viewController];
    viewController.view.frame = self.contentView.frame;
    if (animated) {
        // todo
        
    } else {
        [self.contentView addSubview:viewController.view];
        // todo
        self.activeViewController = viewController;
        [viewController didMoveToParentViewController:self];
    }
    

}


@end
