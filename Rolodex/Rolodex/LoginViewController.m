//
//  LoginViewController.m
//  Rolodex
//
//  Created by Peter Shih on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "JSONKit.h"

@interface LoginViewController (Private)

- (void)loginDidSucceed;

@end

@implementation LoginViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark - View Config
- (UIView *)backgroundView {
  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundLeather.jpg"]] autorelease];
  return bgView;
}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // Add this to main runloop queue
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [self loginDidSucceed];
  }];
}

#pragma mark - Login
- (void)loginDidSucceed {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"me" ofType:@"json"];
  NSData *fixtureData = [NSData dataWithContentsOfFile:filePath];
//  NSString *fixtureString = [[NSString alloc] initWithData:fixtureData encoding:NSUTF8StringEncoding];
  NSDictionary *currentUser = [fixtureData objectFromJSONData];
    
  
  // Store user response into userDefaults  
  [[NSUserDefaults standardUserDefaults] setObject:currentUser forKey:@"currentUser"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [self dismissModalViewControllerAnimated:YES];
}

@end
