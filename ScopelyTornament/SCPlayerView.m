//
//  SCPlayer.m
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import "SCPlayerView.h"


@interface SCPlayerView()

@end

@implementation SCPlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView =[[UIImageView alloc]init];
        self.label=[[UILabel alloc]init];
        CGRect rect =CGRectZero;
        rect.origin.x=0;
        rect.origin.y=0;
        rect.size.width =frame.size.width*0.3;
        rect.size.height=frame.size.height;
        
        self.imageView.frame=CGRectInset(rect, UI_MIN_SPACE, UI_MIN_SPACE);
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor=[UIColor whiteColor];
        rect.origin.x=rect.size.width;
        
        rect.size.width=frame.size.width*0.7;
        self.label.frame=CGRectInset(rect, UI_MIN_SPACE, UI_MIN_SPACE);;
        self.label.text=@"Coming soon";
        
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        
        // Initialization code
    }
    return self;
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
