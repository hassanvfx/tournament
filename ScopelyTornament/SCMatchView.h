//
//  SCMatch.h
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPlayerView.h"
#import "SCObjects.h"

@class SCMatchView;
@protocol SCMatchViewDelegate <NSObject>
@optional
-(void)didTouch:(SCMatchView*)view;

@end

@interface SCMatchView : UIView

-(void)update;

@property(strong)SCMatch *match;
@property(weak)id<SCMatchViewDelegate> delegate;
@end
