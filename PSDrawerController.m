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

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _state = PSDrawerStateClosed;
    _hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slide:) name:kPSDrawerSlide object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide:) name:kPSDrawerHide object:nil];
  }
  return self;
}

- (void)viewDidUnload {
  RELEASE_SAFELY(_bottomViewController);
  RELEASE_SAFELY(_topViewController);
  [super viewDidUnload];
}

- (void)dealloc {
  RELEASE_SAFELY(_bottomViewController);
  RELEASE_SAFELY(_topViewController);
  [super dealloc];
}

#pragma mark - Config View Controllers
- (void)setViewControllers:(NSArray *)viewControllers {
  if ([viewControllers count] == 2) {
    UIViewController *bottomViewController = [viewControllers objectAtIndex:0];
    UIViewController *topViewController = [viewControllers objectAtIndex:1];
    
    // Check to see if the view controllers actually changed
    if (![_bottomViewController isEqual:bottomViewController]) {
      RELEASE_SAFELY(_bottomViewController);
      _bottomViewController = [bottomViewController retain];
      
      // Set Frame
      _bottomViewController.view.frame = self.view.bounds;
      _bottomViewController.view.width = self.view.width - DRAWER_GAP;
      
      [self.view insertSubview:_bottomViewController.view atIndex:0];
    }
    
    if (![_topViewController isEqual:topViewController]) {
      RELEASE_SAFELY(_topViewController);
      _topViewController = [topViewController retain];
      
      // Set Frame
      _topViewController.view.frame = self.view.bounds;
      
      [self.view insertSubview:_topViewController.view atIndex:1];
    }
  }
}

#pragma mark - Slide Drawer
- (void)slide:(NSNotification *)notification {
  UIViewAnimationOptions animationOptions;
  CGFloat left = 0;
  if (_state == PSDrawerStateClosed) {
    animationOptions = UIViewAnimationOptionCurveEaseOut;
    left = self.view.width - DRAWER_GAP;
    _state = PSDrawerStateOpen;
    [_bottomViewController viewWillAppear:YES];
  } else if (_state == PSDrawerStateOpen) {
    animationOptions = UIViewAnimationOptionCurveEaseOut;
    left = 0;
    _state = PSDrawerStateClosed;
    [_bottomViewController viewWillDisappear:NO];
  }
  
  [UIView animateWithDuration:0.4
                        delay:0.0
                      options:animationOptions
                   animations:^{
                     _topViewController.view.left = left;
                   }
                   completion:^(BOOL finished){
                     if (_state == PSDrawerStateOpen) {
                       [_bottomViewController viewDidAppear:YES];
                     } else if (_state == PSDrawerStateClosed) {
                       [_bottomViewController viewDidDisappear:YES];
                     }
                   }];
}

#pragma mark - Hide Drawer
- (void)hide:(NSNotification *)notification {
  UIViewAnimationOptions animationOptions;
  animationOptions = UIViewAnimationOptionCurveEaseOut;
  
  [UIView animateWithDuration:0.4
                        delay:0.0
                      options:animationOptions
                   animations:^{
                     if (_hidden) {
                       _bottomViewController.view.width = self.view.width - DRAWER_GAP;
                       if (_state == PSDrawerStateOpen) {
                         _topViewController.view.left = self.view.width - DRAWER_GAP;
                       } else if (_state == PSDrawerStateClosed) {
                         _topViewController.view.left = 0;
                       }
                       _hidden = NO;
                     } else {
                       _bottomViewController.view.width = self.view.width;
                       _topViewController.view.left = self.view.width;
                       _hidden = YES;
                     }
                   }
                   completion:^(BOOL finished){
                   }];
}

@end
