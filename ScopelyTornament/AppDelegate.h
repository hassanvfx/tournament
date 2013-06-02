//
//  AppDelegate.h
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCTournamentViewController;
@class SCNavigationViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SCTournamentViewController *viewController;
@property (strong, nonatomic) SCNavigationViewController *navigationController;

@end
