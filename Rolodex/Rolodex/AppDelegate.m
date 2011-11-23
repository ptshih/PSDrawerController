//
//  AppDelegate.m
//  Rolodex
//
//  Created by Peter Shih on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PSReachabilityCenter.h"
#import "PSDrawerController.h"

#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"

@interface AppDelegate (Private)

+ (void)setupDefaults;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize drawerController = _drawerController;

+ (void)initialize {
  [self setupDefaults];
}

#pragma mark - Initial Defaults
+ (void)setupDefaults {
  if ([self class] == [AppDelegate class]) {
    // Setup initial defaults
    NSString *initialDefaultsPath = [[NSBundle mainBundle] pathForResource:@"InitialDefaults" ofType:@"plist"];
    assert(initialDefaultsPath != nil);
    
    NSDictionary *initialDefaults = [NSDictionary dictionaryWithContentsOfFile:initialDefaultsPath];
    assert(initialDefaults != nil);
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:initialDefaults];
    
    //
    // Perform any version migrations here
    //
  }
}

#pragma mark - Application Lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Set application stylesheet
  [PSStyleSheet setStyleSheet:@"PSStyleSheet"];
  
  // Start Reachability
  [PSReachabilityCenter defaultCenter];
  
  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  [self.window makeKeyAndVisible];
  
  self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLeather.jpg"]];
  
  // View Controllers
  MenuViewController *mvc = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
  ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
  
  // PS Navigation Controller
  UINavigationController *nc = [[[[NSBundle mainBundle] loadNibNamed:@"PSNavigationController" owner:self options:nil] lastObject] retain];
  nc.viewControllers = [NSArray arrayWithObject:pvc];
  [pvc release];
  
  _drawerController = [[PSDrawerController alloc] initWithNibName:nil bundle:nil];
  [_drawerController setViewControllers:[NSArray arrayWithObjects:mvc, nc, nil]];
  [mvc release];
  [nc release];
  
  [self.window addSubview:_drawerController.view];
  
  // Login
  LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
  [_drawerController presentModalViewController:lvc animated:NO];
  [lvc release];
  
  return YES;
}

- (void)slide {
  [[NSNotificationCenter defaultCenter] postNotificationName:kPSDrawerSlide object:nil];
}

- (void)hide {
  [[NSNotificationCenter defaultCenter] postNotificationName:kPSDrawerHide object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationSuspended object:nil];
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
  [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationBackgrounded object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
  [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationForegrounded object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationResumed object:nil];
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)dealloc
{
  [_drawerController release];
  [_window release];
  [super dealloc];
}

@end
