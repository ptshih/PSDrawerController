//
//  PSDrawerController.h
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

#import <UIKit/UIKit.h>
#import "PSViewController.h"

typedef enum {
  PSDrawerStateClosed = 1,
  PSDrawerStateOpenLeft = 2,
  PSDrawerStateOpenRight = 3,
  PSDrawerStateHiddenLeft = 4,
  PSDrawerStateHiddenRight = 5
} PSDrawerState;

typedef enum{
  PSDrawerPositionLeft = 1,
  PSDrawerPositionRight = 2
} PSDrawerPosition;

@interface PSDrawerController : PSViewController {
  PSDrawerState _state;
  
  UIViewController *_rootViewController;
  UIViewController *_leftViewController;
  UIViewController *_rightViewController;
}

@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, retain, readonly) UIViewController *leftViewController;
@property (nonatomic, retain, readonly) UIViewController *rightViewController;

/**
 Initializes and returns a newly created drawer controller
 
 @param rootViewController The view controller that resides on the top of the stack
 @param leftViewController The view controller that represents the left drawer (optional)
 @param rightViewController The view controller that represents the right drawer (optiona)
 
 @return The initialized drawer controller object or nil if there was a problem initializing the object.
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;

#pragma mark - Slide Drawer
/**
 This method slides the top controller partially off the screen either to the left side or the right side.
 
 Generally you should use one of the slide/hide convenience methods instead of this method, but this method allows more customization.
 
 @param position Choose either PSDrawerPostionLeft or PSDrawerPositionRight
 */
- (void)slideWithPosition:(PSDrawerPosition)position hidden:(BOOL)hidden animated:(BOOL)animated;

/**
 Slides to show the left drawer, partially hiding the root controller
 */
- (void)slideFromLeft;

/**
 Slides to show the right drawer, partially hiding the root controller
 */
- (void)slideFromRight;

/**
 Slides to show the left drawer, completely hiding the root controller
 */
- (void)hideFromLeft;

/**
 Slides to show the right drawer, completely hiding the root controller
 */
- (void)hideFromRight;

@end
