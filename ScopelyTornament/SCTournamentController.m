//
//  SCTournamentController.m
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import "SCTournamentController.h"
#import "AFNetworking.h"
#import "SC.h"
#import "SCWInnerViewController.h"
#import "SCNavigationViewController.h"
#import "NSArray+shufle.h"

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

-(void)flush{
    self.tournamentLoosers=nil;
    self.tournamentWinners=nil;
    self.finalA=nil;
    self.finalB=nil;
}

-(BOOL)isStarted{
    if(self.tournamentWinners.state){
        return YES;
    }else{
        return NO;
    }
}

-(void)startTournamentWithPlayers:(NSArray*)array{
    
   
    self.tournamentWinners =[SCTournament new];
    self.tournamentLoosers =[SCTournament new];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *player =[array objectAtIndex:i];
        SCPlayer *newPlayer=[[SCPlayer alloc]initWithDictionary:player];
        [ self.tournamentWinners.players addObject:newPlayer];
    }

    
    if(!self.tournamentWinners.players.count ){
        // TODO: THROW ERROR !
        return;
    }
  
    NSMutableArray *playersShuffle = [NSMutableArray arrayWithArray:self.tournamentWinners.players];
    [playersShuffle shuffle];
    
    self.tournamentWinners.rootLap=[SCLap new];
    self.tournamentWinners.rootLap.depth=0;
    
    for (int i=0; i<playersShuffle.count; ) {
        
        SCMatch*match =[SCMatch new];
        match.playerA= [playersShuffle objectAtIndex:i];
        match.playerB= [playersShuffle objectAtIndex:i+1];
        match.state=MATCH_IDLE;
        match.index=i/2.0;
        match.lap=0;
        [self.tournamentWinners.rootLap.matches addObject:match];
        i+=2;
    }
    [self.tournamentWinners.laps addObject:self.tournamentWinners.rootLap];
 
    self.finalA = [SCMatch new];
    self.finalA.state=MATCH_UNDEFINED;
    self.finalA.type=MATCH_FINAL;
    
    self.finalB = [SCMatch new];
    self.finalB.state=MATCH_UNDEFINED;
    self.finalB.type=MATCH_FINAL;
    
    [self calculateAndTotalLapsAndFillTournament];
    
}

-(void)setState:(MATCH_STATE)state forMatch:(SCMatch*)match{
    
    match.state =state;
    //move the looser into a new match in the loosers tournament
    
}



-(void)calculateAndTotalLapsAndFillTournament{
    
    float matches =self.tournamentWinners.players.count/2.0;
    
    int count=1;
    while (matches>1) {
        SCLap *lap=[SCLap new];
        matches = roundf(matches/2.0);
        
        SCLap *lapLoosersA=[SCLap new];
        SCLap *lapLoosersB=[SCLap new];
        
        int lapIndex=self.tournamentWinners.laps.count;
       
        for (int i=0; i<matches; i++) {
            
            
            SCMatch *matchLoosersA =[SCMatch new];
            matchLoosersA.state=MATCH_UNDEFINED;
            matchLoosersA.round=ROUND_A;
            matchLoosersA.index=i;
            matchLoosersA.lap =lapIndex;
            matchLoosersA.type=MATCH_LOOSER;
            [lapLoosersA.matches addObject:matchLoosersA];
            
            SCMatch *matchLoosersB =[SCMatch new];
            matchLoosersB.state=MATCH_UNDEFINED;
            matchLoosersB.round=ROUND_B;
            matchLoosersB.index=i;
            matchLoosersB.lap =lapIndex;
            matchLoosersB.type=MATCH_LOOSER;
            [lapLoosersB.matches addObject:matchLoosersB];
       
            SCMatch *match =[SCMatch new];
            match.state=MATCH_UNDEFINED;
            match.index=i;
            match.lap =lapIndex;
            [lap.matches addObject:match];
            
        }
        
      
        
        
        [self.tournamentWinners.laps addObject:lap];
        
        [self.tournamentLoosers.laps addObject:lapLoosersA];
        [self.tournamentLoosers.laps addObject:lapLoosersB];
        
        count+=1;
    }
    
    self.tournamentWinners.total_laps = count;
}

#pragma MARK LOOSERS WINS -
-(void)setWinner:(MATCH_STATE)state forLooserMatch:(SCMatch*)match{
    
    match.state=state;
    int matchIndex=match.index;
    int lap =( (match.lap-1)*2.0) +match.round;
    
    //POPULATE THE WINNER
    SCPlayer *winner=match.playerA;
    if(state==MATCH_WIN_TEAM_B){
        winner=match.playerB;
    }
    
    int winnerLap =[self winnerLapForLooserLap:lap];
    int winnerIndex=[self winnerIndexForLooserLap:lap index:matchIndex];
    
    if(winnerLap<self.tournamentLoosers.laps.count){
        SCLap *winnerLapObject=  [self.tournamentLoosers.laps objectAtIndex:winnerLap];
        SCMatch *winnerMatch = [winnerLapObject.matches objectAtIndex:winnerIndex];
        
        if(winnerMatch.playerA.name){
            winnerMatch.playerB =winner;
            //        match.finished=YES;
            winnerMatch.state=MATCH_IDLE;
        }else{
            winnerMatch.playerA =winner;
        }
    }else{
        if(self.finalA.playerA.name){
            self.finalA.playerB =winner;
            self.finalA.state=MATCH_IDLE;
        }else{
            self.finalA.playerA =winner;
        }
    }
}

#pragma mark FINAL
-(void)setWinner:(MATCH_STATE)state forFinal:(SCMatch*)match{
    if(match==self.finalA){
        
        self.finalA.finished=YES;
        self.finalB.playerA =self.finalA.playerB;
        self.finalB.playerB =self.finalA.playerA;
        self.finalB.state=MATCH_IDLE;
   
    }else{
        self.finalB.state=state;
        self.finalB.finished=YES;
        
        SCPlayer *winner=match.playerA;
        if(state==MATCH_WIN_TEAM_B){
            winner=match.playerB;
        }
        
        
        SCWInnerViewController *viewController =[[SCWInnerViewController alloc]initWithPLayer:winner];
        [[SC navigationController] pushViewController:viewController animated:YES];
        
        //WINNER !!
    }
}

#pragma mark loosers
-(int)winnerLapForLooserLap:(int)lap{
    
    //HARDCORE THIS FOR NOW
    int result=lap+1;
    return result;
}


-(int)winnerIndexForLooserLap:(int)lap index:(int)index{
    
    //HARDCORE THIS FOR NOW
    int result =0;
    switch (lap) {
        case 0:
            result=index;
            break;
        case 1:
        case 2:
        case 3:
            result=0;
            break;
        default:
            break;
    }
    return result;
}


#pragma MARK WINNERS WINS -
-(void)setWinner:(MATCH_STATE)state forWinnerMatch:(SCMatch*)match{
    
    match.state=state;
    match.finished=YES;
    int matchIndex=match.index;
    int lap =match.lap;
    
    //POPULATE THE WINNER
    SCPlayer *winner=match.playerA;
    if(state==MATCH_WIN_TEAM_B){
        winner=match.playerB;
    }
    
    int winnerLap =[self winnerLapForWinnerLap:lap];
    int winnerIndex=[self winnerIndexForWinnerLap:lap index:matchIndex];
    
    if(winnerLap<self.tournamentWinners.laps.count){
        
        SCLap *winnerLapObject=  [self.tournamentWinners.laps objectAtIndex:winnerLap];
        SCMatch *winnerMatch = [winnerLapObject.matches objectAtIndex:winnerIndex];
        
        if(winnerMatch.playerA.name){
            winnerMatch.playerB =winner;
            winnerMatch.state=MATCH_IDLE;
        }else{
            winnerMatch.playerA =winner;
        }
    }else{
        if(self.finalA.playerA.name){
            self.finalA.playerB =winner;
            self.finalA.state=MATCH_IDLE;
        }else{
            self.finalA.playerA =winner;
        }
    }
    
    //POPULATE IN THE LOOSERS
    SCPlayer *looser=match.playerA;
    if(state==MATCH_WIN_TEAM_A){
        looser=match.playerB;
    }
    int looserLap =[self looserLapForWinnerLap:lap];
    int looserIndex=[self looserIndexForWinnerLap:lap index:matchIndex];
    
    SCLap *looserLapObject=  [self.tournamentLoosers.laps objectAtIndex:looserLap];
    SCMatch *looserMatch = [looserLapObject.matches objectAtIndex:looserIndex];
    
    if(looserMatch.playerA.name){
        looserMatch.playerB =looser;
        looserMatch.state=MATCH_IDLE;
    }else{
        looserMatch.playerA =looser;
    }
    
}

#pragma mark winners

-(int)winnerLapForWinnerLap:(int)lap{
    
    //HARDCORE THIS FOR NOW
    int result=lap+1;
    return result;
}


-(int)winnerIndexForWinnerLap:(int)lap index:(int)index{
    
    //HARDCORE THIS FOR NOW
    int result=trunc(index/2.0);
    return result;
}

#pragma mark loosers
-(int)looserLapForWinnerLap:(int)lap{
    
    //HARDCORE THIS FOR NOW
    int result=0;
    switch (lap) {
        case 0:
            result=0;
            break;
        case 1:
            result=1;
            break;
        case 2:
            result=3;
            break;
        default:
            break;
    }
    return result;
}


-(int)looserIndexForWinnerLap:(int)lap index:(int)index{
    
    //HARDCORE THIS FOR NOW
    int result=0;
    switch (lap) {
        case 0:
            result=trunc(index/2.0);
            break;
        case 1:
            result=index;
            break;
        case 2:
            result=0;
            break;
        default:
            break;
    }
    return result;
}

@end
