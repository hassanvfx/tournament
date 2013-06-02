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

@property(strong,nonatomic)SCTournament *tournamentWinners;
@property(strong,nonatomic)SCTournament *tournamentLoosers;

@property(strong,nonatomic)SCMatch *finalA;
@property(strong,nonatomic)SCMatch *finalB;

#pragma  mark NETWORKING
-(void)startFromServerWithCompletion:(SCTournamentSetupBlock)block;

#pragma  mark LIFECYCLE
-(void)flush;
-(BOOL)isStarted;

-(void)setWinner:(MATCH_STATE)state forWinnerMatch:(SCMatch*)match;
-(void)setWinner:(MATCH_STATE)state forLooserMatch:(SCMatch*)match;

-(void)setWinner:(MATCH_STATE)state forFinal:(SCMatch*)match;

@end
