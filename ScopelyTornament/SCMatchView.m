//
//  SCMatch.m
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import "SCMatchView.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface SCMatchView ()

@property(strong)SCPlayerView *playerA;
@property(strong)SCPlayerView *playerB;
@property(strong)UIButton *button;
@end

@implementation SCMatchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect=frame;
        rect.origin=CGPointZero;
        rect.size.height*=0.5;
        self.playerA =[[SCPlayerView alloc]initWithFrame:rect];
        rect.origin.y=rect.size.height;
        self.playerB=[[SCPlayerView alloc]initWithFrame:rect];
        
        [self addSubview:self.playerA];
        [self addSubview:self.playerB];
        rect=frame;
        rect.origin=CGPointZero;
        self.button =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.button addTarget:self action:@selector(didTouch) forControlEvents:UIControlEventTouchUpInside];
        self.button.frame=rect;
        [self addSubview:self.button];
        
        
        // border radius
        [self.layer setCornerRadius:30.0f];
        
        // border
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.layer setBorderWidth:1.5f];
        
        self.clipsToBounds=YES;
        
        // Initialization code
    }
    return self;
}

-(void)didTouch{
    if([self.delegate respondsToSelector:@selector(didTouch:)]){
        [self.delegate didTouch:self];
    }
}

-(void)update{

    if (self.match) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.playerA.alpha=0.0;
                self.playerB.alpha=0.0;
                self.backgroundColor=[UIColor clearColor];
                switch (self.match.state) {
                    case MATCH_UNDEFINED:
                        
                        self.playerA.alpha=0.25;
                        self.playerB.alpha=0.25;
                        self.backgroundColor=[UIColor clearColor];
                        
                        break;
                    case MATCH_IDLE:
                        self.playerA.alpha=1.0;
                        self.playerB.alpha=1.0;
                        self.backgroundColor=[UIColor whiteColor];
                        break;
                    case MATCH_WIN_TEAM_A:
                        self.playerA.alpha=0.75;
                        self.playerB.alpha=0.15;
                        self.backgroundColor=[UIColor lightGrayColor];
                        break;
                    case MATCH_WIN_TEAM_B:
                        
                        self.playerA.alpha=0.15;
                        self.playerB.alpha=0.75;
                        self.backgroundColor=[UIColor lightGrayColor];
                        break;
                    default:
                        break;
                }
            }];
        });
        
        if(self.match.playerA){
            if(self.match.playerA.name){

            self.playerA.label.text=self.match.playerA.name;
                
                 __weak SCMatchView *me=self;
                NSString *url=self.match.playerA.imageurlstring;
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
//                request.cachePolicy=policy;
                AFImageRequestOperation *operation;
                operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                 imageProcessingBlock:^UIImage *(UIImage *image) {
                                                                     
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         [me.playerA.imageView setImage:image];
                                                                         me.playerA.imageView.alpha=0.0;
                                                                         [UIView animateWithDuration:0.5 animations:^{
                                                                             me.playerA.imageView.alpha=1.0;
                                                                         }];
                                                                     });
                                                                     
                                                                     return image;
                                                                 } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                     
                                                                    
                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                     
                                                                    
                                                                 }];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    [operation start];
                });
            }
        }
        
        if(self.match.playerB){
             if(self.match.playerB.name){
                 self.playerB.label.text=self.match.playerB.name;
                 
                 NSString *url=self.match.playerB.imageurlstring;
                 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
                 //                request.cachePolicy=policy;
                 AFImageRequestOperation *operation;
                 
                 __weak SCMatchView *me=self;
                 operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                  imageProcessingBlock:^UIImage *(UIImage *image) {
                                                                      
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          [me.playerB.imageView setImage:image];
                                                                          me.playerB.imageView.alpha=0.0;
                                                                          [UIView animateWithDuration:0.5 animations:^{
                                                                              me.playerB.imageView.alpha=1.0;
                                                                          }];
                                                                      });
                                                                      
                                                                      return image;
                                                                  } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                      
                                                                      
                                                                  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                      
                                                                      
                                                                  }];
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                     
                     [operation start];
                 });
             }
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
