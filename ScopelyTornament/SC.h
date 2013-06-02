//
//  SC.h
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCTournamentController.h"
#import "AppDelegate.h"
@interface SC : NSObject


+ (SCTournamentController *)tournament;
+ (SC *) manager;
+ (SCNavigationViewController *) navigationController;
@end
