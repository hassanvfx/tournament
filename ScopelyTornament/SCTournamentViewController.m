//
//  SCTournamentViewController.m
//  ScopelyTornament
//
//  Created by hassanvfx on 01/06/13.
//  Copyright (c) 2013 random interactive. All rights reserved.
//

#import "SCTournamentViewController.h"
#import "SCObjects.h"
#import "SCMatchView.h"
#import "UIAlertView+Blocks.h"




@interface SCTournamentViewController ()

@property(strong)UIView *tournamentView;
@property(strong)UIScrollView *scrollView;
@end

@implementation SCTournamentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor lightGrayColor];
	// Do any additional setup after loading the view.
    [self displayTournament];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void)displayTournament{
    
    if(![[SC tournament]isStarted]){
        [[SC tournament]startFromServerWithCompletion:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self displayTournamentNow];
            });
        }];
        return;
    }
    [self displayTournamentNow];
}

-(void)displayTournamentNow{
    
    int players =[SC tournament].tournament.players.count;
    int laps =[SC tournament].tournament.laps.count;
    
    int h =(players/2.0)*(UI_MATCH_HEIGT+UI_LINE_HEIGHT);
    int w =laps*(UI_MATCH_WIDTH+UI_LINE_WIDTH);
    float minZoom = self.view.bounds.size.height/h;
    
    CGRect rect=CGRectMake(0, 0, w, h);
    self.scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.scrollView setContentSize:rect.size];
    [self.scrollView setMinimumZoomScale:minZoom];
    [self.scrollView setMaximumZoomScale:1.0];
    [self.scrollView setBounces:YES];
    [self.scrollView setBouncesZoom:YES];
    [self.view addSubview:self.scrollView];
    double delayInSeconds = 1.0;
    __weak SCTournamentViewController *me=self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         [me.scrollView setZoomScale:minZoom animated:YES];
    });
   
    self.scrollView.delegate=self;
    
    self.tournamentView=[[UIView alloc]initWithFrame:rect];
//    self.tournamentView.backgroundColor =[UIColor greenColor];
    [self.scrollView addSubview:self.tournamentView];
    
    for (int i=0; i<laps; i++) {
        
        int lapsNum =i+1;
        int lapsHeight = h/lapsNum;
        int posY = (h-lapsHeight)/2.0;
        int posX = (UI_MATCH_WIDTH+UI_LINE_WIDTH)*i;
        
        CGRect rect =CGRectMake(posX, posY, UI_MATCH_WIDTH, lapsHeight);
        UIView *lapse =[[UIView alloc]initWithFrame:rect];
//        lapse.backgroundColor=[UIColor redColor];
        
        [self.tournamentView addSubview:lapse];
        SCLap *lap =[[SC tournament].tournament.laps objectAtIndex:i];
        for (int j=0; j<lap.matches.count; j++) {
            int posY = (UI_MATCH_HEIGT+UI_LINE_HEIGHT)*j;
            CGRect rect =CGRectMake(0, posY, UI_MATCH_WIDTH, UI_MATCH_HEIGT);
            SCMatchView *match =[[SCMatchView alloc]initWithFrame:rect];
            match.backgroundColor=[UIColor whiteColor   ];
            match.match =[lap.matches objectAtIndex:j];
            match.delegate=self;
            [match update];
            [lapse addSubview:match];
            
        }
        
    }
    
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return  self.tournamentView;
}

-(void)didTouch:(SCMatchView*)match{
    if(!match.match.state){
        //PLAYERS ARE UNDEFINED
        return;
    }
    NSString *text=[NSString stringWithFormat:@"%@ or %@",match.match.playerA.name , match.match.playerB.name];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Play !"
                                                    message:@"Who should Win?"
                                                   delegate:nil
                                          cancelButtonTitle:match.match.playerA.name
                                          otherButtonTitles:match.match.playerB.name, nil];
    
    [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == [alertView cancelButtonIndex]) {
            
            
            
        } else {
            
           
            
        }
    }];
}
@end
