//
//  AppDelegate.h
//  Rolodex
//
//  Created by Peter Shih on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSDrawerController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
  PSDrawerController *_drawerController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) PSDrawerController *drawerController;

- (void)slide;
- (void)hide;

@end
