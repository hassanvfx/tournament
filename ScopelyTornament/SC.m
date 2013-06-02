//
//  SC.m
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import "SC.h"

@interface SC ()

@property(strong)SCTournamentController *tournamentController;

@end

@implementation SC

+ (SC *) manager{
    static dispatch_once_t pred;
    static SC *manager = nil;
    
    dispatch_once(&pred, ^{
        manager = [[SC alloc] init];
    });
 
    return manager;
    
}

+ (SCTournamentController *) tournament{
    static dispatch_once_t pred;
    static SCTournamentController *manager = nil;
    
    dispatch_once(&pred, ^{
        manager = [[SCTournamentController alloc] init];
    });
    
    return manager;
    
}

-(id)init{
    
    self=[super init];
    if(self){
        
        _tournamentController =[SCTournamentController new];
        
    }
    return self;
}
@end
