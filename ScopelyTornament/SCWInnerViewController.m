//
//  SCWInnerViewController.m
//  ScopelyTornament
//
//  Created by hassanvfx on 02/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import "SCWInnerViewController.h"
#import "AFNetworking.h"

@interface SCWInnerViewController()

@property(strong)UIImageView *imageView;
@property(strong)UILabel *labelTitle;
@property(strong)UILabel *labelHeader;
@property(strong)SCPlayer *player;
@end


@implementation SCWInnerViewController

-(id)initWithPLayer:(SCPlayer*)player{
    self=[super init];
    if(self){
        self.player=player;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.labelHeader=[UILabel new];
    CGRect rect=CGRectZero;
    rect.size.width=self.view.bounds.size.width;
    rect.size.height =self.view.bounds.size.height*0.2;
    self.labelHeader.frame=rect ;
    self.labelHeader.textAlignment=NSTextAlignmentCenter;
    self.labelHeader.text=@"WINNER!!";
    [self.view addSubview:self.labelHeader];
    
    
    self.imageView =[[UIImageView alloc]init];
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    rect.origin.y+=rect.size.height;
    rect.size.height=self.view.bounds.size.height*0.6;
    self.imageView.frame=rect;
    [self.view addSubview:self.imageView];
    
    self.labelTitle=[UILabel new];
    rect.origin.y+=rect.size.height;
    rect.size.width=self.view.bounds.size.width;
    rect.size.height =self.view.bounds.size.height*0.2;
    self.labelTitle.textAlignment=NSTextAlignmentCenter;
    self.labelTitle.frame=rect ;
    [self.view addSubview:self.labelTitle];
    self.labelTitle.text=self.player.name;
    
    
    
    __weak SCWInnerViewController  *me=self;
    NSString *url=self.player.imageurlstring;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    //                request.cachePolicy=policy;
    AFImageRequestOperation *operation;
    operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                     imageProcessingBlock:^UIImage *(UIImage *image) {
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [me.imageView setImage:image];
                                                         });
                                                         
                                                         return image;
                                                     } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                         
                                                         
                                                     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                         
                                                         
                                                     }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [operation start];
    });
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor lightGrayColor];
	// Do any additional setup after loading the view.
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
