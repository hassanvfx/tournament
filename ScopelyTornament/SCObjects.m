//
//  SCObjects.m
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import "SCObjects.h"
#import "NSArray+shufle.h"


@implementation SCPlayer

-(id)  initWithDictionary:(NSDictionary*)data{
    self=[super init];
    if(self) {
        self.pid=               [[data objectForKey:SC_ID] copy];
        self.imageurlstring =   [data objectForKey:SC_IMAGE];
        self.name =             [[data objectForKey:SC_NAME]copy];
        self.updated =          [data objectForKey:SC_UPDATED];
      
    }
    return self;
}

@end

@implementation SCMatch

-(id)init{
    self=[super init];
    if(self){
        _state = MATCH_UNDEFINED;
    }
    return self;
}



@end

@implementation SCLap

-(id)init{
    self=[super init];
    if(self){
        _state = LAP_IDLE;
        _matches = [NSMutableArray new];
    }
    return self;
}



@end

@implementation SCTournament

-(id)init{
    self=[super init];
    if(self){
        _state = TORUNAMENT_IDLE;
        _players =[NSMutableArray new];
        _laps =[NSMutableArray new];
        _current_lap =0;
    }
    return self;
}
-(int)nextmatchid{
    return [_laps count]+1;
}





@end