//
//  PSDrawerController.m
//  PSKit
//
//  Created by Peter Shih on 11/22/11.
//  Copyright (c) 2011 Peter Shih. All rights reserved.
//

/*
 Copyright (C) 2011 Peter Shih. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "PSDrawerController.h"

#define DRAWER_WIDTH 260.0
#define DRAWER_GAP 60.0

@implementation PSDrawerController

@synthesize rootViewController = _rootViewController;
@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;

#pragma mark - Init
- (id)initWithRootViewController:(UIViewController *)rootViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _rootViewController = [rootViewController retain];
    _leftViewController = [leftViewController retain];
    _rightViewController = [rightViewController retain];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Set default state variables
    _state = PSDrawerStateClosed;
  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {  
  RELEASE_SAFELY(_rootViewController);
  RELEASE_SAFELY(_leftViewController);
  RELEASE_SAFELY(_rightViewController);
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Left - Bottom
  if (_leftViewController) {
    _leftViewController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _leftViewController.view.hidden = YES;
    [self.view addSubview:_leftViewController.view];
  }
  
  // Right - Middle
  if (_rightViewController) {
    _rightViewController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _rightViewController.view.hidden = YES;
    [self.view addSubview:_rightViewController.view];
  }
  
  // Root - Top
  _rootViewController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
  [self.view addSubview:_rootViewController.view];
}

#pragma mark - View Controller Seters
- (void)setRootViewController:(UIViewController *)rootViewController {
  [_rootViewController autorelease];
  [_rootViewController.view removeFromSuperview];
  _rootViewController = [rootViewController retain];
  _rootViewController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
  [self.view addSubview:_rootViewController.view];
  
  // Set Root Frame
  CGFloat topLeft = 0.0;
  switch (_state) {
    case PSDrawerStateClosed:
      topLeft = 0.0;
      break;
    case PSDrawerStateOpenLeft:
      topLeft = self.view.width - DRAWER_GAP;
      break;
    case PSDrawerStateOpenRight:
      topLeft = 0.0 - (self.view.width - DRAWER_GAP);
      break;
    default:
      topLeft = 0.0;
      break;
  }
  _rootViewController.view.frame = CGRectMake(topLeft, 0, self.view.width, self.view.height);
}

#pragma mark - Slide Drawer
- (void)slideFromLeft {
  [self slideWithPosition:PSDrawerPositionLeft];
}

- (void)slideFromRight {
  [self slideWithPosition:PSDrawerPositionRight];
}

- (void)slideWithPosition:(PSDrawerPosition)position {
  UIViewAnimationOptions animationOptions;
  animationOptions = UIViewAnimationOptionCurveEaseOut;
  CGFloat left = 0;
  BOOL opened = !(_state == PSDrawerStateClosed);
  if (opened) {
    left = 0;
    if (position == PSDrawerPositionLeft) {
      [_leftViewController viewWillDisappear:YES];
    } else if (position == PSDrawerPositionRight) {
      [_rightViewController viewWillDisappear:YES];
    }
  } else {
    if (position == PSDrawerPositionLeft) {
      left = self.view.width - DRAWER_GAP;
      [_leftViewController viewWillAppear:YES];
      _leftViewController.view.hidden = NO;
    } else if (position == PSDrawerPositionRight) {
      left = 0 - (self.view.width - DRAWER_GAP);
      [_rightViewController viewWillAppear:YES];
      _rightViewController.view.hidden = NO;
    }
  }

  void (^slide)(BOOL, PSDrawerPosition) = ^(BOOL opened, PSDrawerPosition position) {
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:animationOptions
                     animations:^{
                       _rootViewController.view.left = left;
                     }
                     completion:^(BOOL finished){
                       if (!opened) {
                         if (position == PSDrawerPositionLeft) {
                           [_leftViewController viewDidAppear:YES];
                           _state = PSDrawerStateOpenLeft;
                         } else if (position == PSDrawerPositionRight) {
                           [_rightViewController viewDidAppear:YES];
                           _state = PSDrawerStateOpenRight;
                         }
                       } else {
                         if (position == PSDrawerPositionLeft) {
                           [_leftViewController viewDidDisappear:YES];
                           _leftViewController.view.hidden = YES;
                         } else if (position == PSDrawerPositionRight) {
                           [_rightViewController viewDidAppear:YES];
                           _rightViewController.view.hidden = YES;
                         }
                         _state = PSDrawerStateClosed;
                       }
                     }];
  };

  slide(opened, position); // execute block
}

#pragma mark - Hide Drawer
- (void)hideFromLeft {
  [self hideWithPosition:PSDrawerPositionLeft];
}

- (void)hideFromRight {
  [self hideWithPosition:PSDrawerPositionRight];
}

- (void)hideWithPosition:(PSDrawerPosition)position {
  UIViewAnimationOptions animationOptions;
  animationOptions = UIViewAnimationOptionCurveEaseOut;
  [UIView animateWithDuration:0.4
                        delay:0.0
                      options:animationOptions
                   animations:^{
                     if (position == PSDrawerPositionLeft) {
                       _rootViewController.view.left = self.view.width;
                     } else if (position == PSDrawerPositionRight) {
                       _rootViewController.view.left = 0 - self.view.width;
                     }                     
                   }
                   completion:^(BOOL finished){
                   }];
}

@end
