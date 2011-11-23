//
//  PSDrawerController.h
//  Rolodex
//
//  Created by Peter Shih on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSViewController.h"

#define kPSDrawerSlide @"PSDrawerSlide"
#define kPSDrawerHide @"PSDrawerHide"

typedef enum {
  PSDrawerStateClosed = 1,
  PSDrawerStateOpen = 2
} PSDrawerState;

@interface PSDrawerController : PSViewController {
  PSDrawerState _state;
  BOOL _hidden;
  
  UIViewController *_bottomViewController;
  UIViewController *_topViewController;
}

#pragma mark - Config View Controllers
/**
 The array in this property must contain exactly two view controllers. The first view controller is the bottom (navigation) controller. The second view controller is the top (root) controller.
 */
- (void)setViewControllers:(NSArray *)viewControllers;

#pragma mark - Slide Drawer
/**
 This method slides the top controller partially off the screen.
 */
- (void)slide:(NSNotification *)notification;

#pragma mark - Hide Drawer
/**
 This method slides the top controller completely off the screen.
 */
- (void)hide:(NSNotification *)notification;

@end
