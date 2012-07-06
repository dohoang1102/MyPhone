//
//  AppDelegate.h
//  MyPhone
//
//  Created by Pavel Gnatyuk on 1/20/12.
//  Copyright (c) 2012 Software Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainViewController;

@end
