//
//  LoginViewController.m
//  Twitter_GZ
//
//  Created by gongzhen on 8/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "AppDelegate.h"
#import "ContainerViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIImageView *loginImageView;

@end

@implementation LoginViewController

#pragma mark - Lazy Loading
- (UIButton *)loginButton
{
    if (_loginButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Sign in with Twitter" forState: UIControlStateNormal];
        [button setTitleShadowColor:[UIColor colorWithRed:77.0 / 255.0 green:77.0/ 255.0 blue:77.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.0;
        button.layer.cornerRadius = 3.0;
        _loginButton = button;
    }
    return _loginButton;
}

- (UIImageView *)loginImageView
{
    if (_loginImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"TwitterLoginLogo.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];        
        _loginImageView = imageView;
    }
    return _loginImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:57.0 / 255.0 green:170.0/255.0 blue:242.0/255.0 alpha:1.0];
    // Do any additional setup after loading the view from its nib.
    [self configureViews];
    [self configureImagePositions];
    [self configureButtonPositions];
}

- (void) configureViews
{
    [self.view addSubview:self.loginImageView];
    [self.view addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onLogin:(UIButton *)button
{
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user) {
            // Modally present tweets view
            NSLog(@"Welcome, %@", user.name);
            ContainerViewController *cvc = [[ContainerViewController alloc] init];
            [[[[UIApplication sharedApplication] delegate] window] setRootViewController:cvc];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Login failed with error: %@", error);
        }
    }];        
}

-(void)configureImagePositions
{
    // self.loginImage
    self.loginImageView.translatesAutoresizingMaskIntoConstraints = false;
    // loginImageView weight
    NSLayoutConstraint *imageViewWidth = [NSLayoutConstraint constraintWithItem:self.loginImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:77];
    [self.view addConstraint:imageViewWidth];
    
    // loginImageView height
    NSLayoutConstraint *imageViewHeight = [NSLayoutConstraint constraintWithItem:self.loginImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:77];
    [self.view addConstraint:imageViewHeight];
    // loginImageView alignX
    NSLayoutConstraint *imageViewAlignX = [NSLayoutConstraint constraintWithItem:self.loginImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
    [self.view addConstraint:imageViewAlignX];
    // loginImage View top margin
    NSLayoutConstraint *imageViewTop = [NSLayoutConstraint constraintWithItem:self.loginImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:110];
    [self.view addConstraint:imageViewTop];
}

-(void)configureButtonPositions
{
    // loginButton
    self.loginButton.translatesAutoresizingMaskIntoConstraints = false;
    // loginButton weight
    NSLayoutConstraint* loginButtonWidth = [NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:170];
    [self.view addConstraint:loginButtonWidth];
    // loginButton height
    NSLayoutConstraint* loginButtonHeight = [NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [self.view addConstraint:loginButtonHeight];
    // loginButton alignX
    NSLayoutConstraint* loginButtonAlignX = [NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
    [self.view addConstraint:loginButtonAlignX];
    // loginButton interitem distance with loginView
    NSLayoutConstraint* loginButtonVertical = [NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.loginImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:150];
    [self.view addConstraint:loginButtonVertical];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
