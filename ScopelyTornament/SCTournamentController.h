//
//  SCTournamentController.h
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCObjects.h"

typedef void (^SCTournamentSetupBlock)(NSError *error);

@interface SCTournamentController : NSObject

@property(strong,nonatomic)SCTournament *tournament;
@property(strong,nonatomic)SCTournament *tournamentLoosers;


#pragma  mark NETWORKING
-(void)startFromServerWithCompletion:(SCTournamentSetupBlock)block;

#pragma  mark LIFECYCLE
-(BOOL)isStarted;

@end
