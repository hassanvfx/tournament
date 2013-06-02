//
//  SCObjects.h
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    

    MATCH_UNDEFINED    =      0,
    MATCH_IDLE         =      1,
    MATCH_WIN_TEAM_A   =      2,
    MATCH_WIN_TEAM_B   =      3
    
} MATCH_STATE;


typedef enum {
    
    
    LAP_IDLE            =      0,
    LAP_IN_PROGRESS     =      1,
    LAP_FINISHED        =      2
    
} LAP_STATE;

typedef enum {
    
    
    TORUNAMENT_IDLE                 =      0,
    TORUNAMENT_IDLE_IN_PROGRESS     =      1,
    TORUNAMENT_IDLE_FINISHED        =      2
    
} TORUNAMENT_STATE;


/*
 PLAYER SCHEMA
 "id" 		: 3,
 "name" 		: "Chicago Bulls",
 "image" 	: "https://s3.amazonaws.com/misc-withbuddies.com/ClientChallenge/chicagoBulls.png",
 "updated"	: "\"\/Date(1244332800+0000)\/\""
 */

@interface SCPlayer : NSObject
-(id)  initWithDictionary:(NSDictionary*)data;
@property(strong,nonatomic)NSString *pid;
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *imageurlstring;
@property(strong,nonatomic)NSString *updated;

@end

@interface SCMatch : NSObject

@property(strong,nonatomic)SCPlayer *playerA;
@property(strong,nonatomic)SCPlayer *playerB;
@property(assign,nonatomic)MATCH_STATE state;
@property(assign,nonatomic)int index;
@property(assign,nonatomic)int nextMatch;

@end

@interface SCLap :NSObject

@property(strong,nonatomic)NSMutableArray *matches;
@property(assign,nonatomic)int depth;
@property(assign,nonatomic)LAP_STATE  state;

@end

@interface SCTournament : NSObject

@property(strong,nonatomic)NSMutableArray *players;
@property(strong,nonatomic)NSMutableArray *laps;
@property(strong,nonatomic)SCLap *rootLap;
@property(assign,nonatomic)TORUNAMENT_STATE state;
@property(assign,nonatomic)int current_lap;
@property(assign,nonatomic)int total_laps;

-(void)startRandom;
-(int)nextmatchid;

@end



