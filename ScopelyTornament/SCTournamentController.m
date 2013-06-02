//
//  SCTournamentController.m
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import "SCTournamentController.h"
#import "AFNetworking.h"

@interface SCTournamentController ()

@property(strong,nonatomic)AFHTTPClient *httpClient;


@end

@implementation SCTournamentController



-(id)init{
    
    self=[super init];
    if(self){
        
    }
    return self;
}

#pragma  mark NETWORKING

-(AFHTTPClient*)httpClient{
    if(!_httpClient){
        NSURL *url = [NSURL URLWithString:SC_API_BASE_URL];
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    }
    
    return _httpClient;
}

-(void)startFromServerWithCompletion:(SCTournamentSetupBlock)block{
    
    
    
    [self.httpClient
     getPath:SC_API_PLAYERS
     parameters:@{}
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if([[dict objectForKey:SC_RESPONSE]intValue]==200){
             
             NSArray*data =[dict objectForKey:SC_DATA];
             [self startTournamentWithPlayers:data];
             
             if(block){
                 block(nil);
             }
         }else{
             if (block) {
                 block( [NSError errorWithDomain:SC_API_PLAYERS
                                            code:[[dict objectForKey:SC_RESPONSE]intValue]
                                        userInfo:responseObject]);
             }
         }
        
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (block) {
             block(error);
         }
     }
     ];

}




#pragma  mark LIFECYCLE

-(BOOL)isStarted{
    if(self.tournament.state){
        return YES;
    }else{
        return NO;
    }
}

-(void)startTournamentWithPlayers:(NSArray*)array{
    
   
    self.tournament =[SCTournament new];

    
    for (int i=0; i<array.count; i++) {
        NSDictionary *player =[array objectAtIndex:i];
        SCPlayer *newPlayer=[[SCPlayer alloc]initWithDictionary:player];
        [ self.tournament.players addObject:newPlayer];
    }

    
    if(!self.tournament.players.count ){
        // TODO: THROW ERROR !
        return;
    }
  
    NSMutableArray *playersShuffle = [self.tournament.players copy];
 
    
    self.tournament.rootLap=[SCLap new];
    self.tournament.rootLap.depth=0;
    
    for (int i=0; i<playersShuffle.count; ) {
        
        SCMatch*match =[SCMatch new];
        match.playerA= [playersShuffle objectAtIndex:i];
        match.playerB= [playersShuffle objectAtIndex:i+1];
        match.state=MATCH_IDLE;
        
        [self.tournament.rootLap.matches addObject:match];
        i+=2;
    }
    [self.tournament.laps addObject:self.tournament.rootLap];
    [self calculateAndTotalLapsAndFillTournament];
    
}


-(void)calculateAndTotalLapsAndFillTournament{
    
    float matches =self.tournament.players.count/2.0;
  
    int count=1;
    while (matches>1) {
        SCLap *lap=[SCLap new];
        matches = roundf(matches/2.0);
        for (int i=0; i<matches; i++) {
            SCMatch *match =[SCMatch new];
            match.state=MATCH_UNDEFINED;
            [lap.matches addObject:match];
        }
        [self.tournament.laps addObject:lap];
        count+=1;
    }
    
     self.tournament.total_laps = count;
}


@end
