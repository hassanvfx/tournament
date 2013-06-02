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

@property(strong)UIView *tournamentWinnersView;
@property(strong)UIView *tournamentLoosersView;
@property(strong)UIView *tournamentFinalistView;
@property(strong)UIView *tournamentsView;
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

-(void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New Game"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(restart)];
   
    self.navigationItem.leftBarButtonItem = rightButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Help"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(help)];
    
    self.navigationItem.rightBarButtonItem= leftButton;
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
-(void)restart{
    [[SC tournament] flush];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayTournament];
    });
}

-(void)help{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help"
                                                    message:@"Touch on the white boxes to select winners!\nBlame the developer at hassanvfx@gmail.com"
                                                   delegate:nil
                                          cancelButtonTitle:@"Got it!"
                                          otherButtonTitles: nil];
    [alert show];
}

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

-(void)createTournamentWinnersView{
    
    if(self.tournamentWinnersView){
        for( UIView*view in self.tournamentWinnersView.subviews){
            [view removeFromSuperview];
        }
        
        [self.tournamentWinnersView removeFromSuperview];
    }
    
    
    int players =[SC tournament].tournamentWinners.players.count;
    int laps =[SC tournament].tournamentWinners.laps.count;
    
    int h =(players/2.0)*(UI_MATCH_HEIGT+UI_LINE_HEIGHT);
    int w =laps*(UI_MATCH_WIDTH+UI_LINE_WIDTH);
    
    CGRect rect=CGRectMake(0, 0, w, h);
 
    self.tournamentWinnersView=[[UIView alloc]initWithFrame:rect];
    
    for (int i=0; i<laps; i++) {
        
        int lapsNum =i+1;
        int lapsHeight = h/lapsNum;
        int posY = (h-lapsHeight)/2.0;
        int posX = (UI_MATCH_WIDTH+UI_LINE_WIDTH)*i;
        
        CGRect rect =CGRectMake(posX, posY, UI_MATCH_WIDTH, lapsHeight);
        UIView *lapse =[[UIView alloc]initWithFrame:rect];
        //        lapse.backgroundColor=[UIColor redColor];
        
        [self.tournamentWinnersView addSubview:lapse];
        SCLap *lap =[[SC tournament].tournamentWinners.laps objectAtIndex:i];
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



-(void)createTournamentLoosersView{
    
    if(self.tournamentLoosersView){
        for( UIView*view in self.tournamentLoosersView.subviews){
            [view removeFromSuperview];
        }
        
        [self.tournamentLoosersView removeFromSuperview];
    }
    
    
    int players =[SC tournament].tournamentWinners.players.count;
    int laps =[SC tournament].tournamentLoosers.laps.count;
    
    int h =(players/2.0)*(UI_MATCH_HEIGT+UI_LINE_HEIGHT);
    int w =laps*(UI_MATCH_WIDTH+UI_LINE_WIDTH);
    
    CGRect rect=CGRectMake(0, 0, w, h);
    
    self.tournamentLoosersView=[[UIView alloc]initWithFrame:rect];
    
    for (int i=0; i<laps; i++) {
        
        int lapsNum =i+1;
        int lapsHeight = h/lapsNum;
        int posY = 0;
        int posX = (UI_MATCH_WIDTH+UI_LINE_WIDTH)*i;
        
        CGRect rect =CGRectMake(posX, posY, UI_MATCH_WIDTH, lapsHeight);
        UIView *lapse =[[UIView alloc]initWithFrame:rect];
        //        lapse.backgroundColor=[UIColor redColor];
        
        [self.tournamentLoosersView addSubview:lapse];
        SCLap *lap =[[SC tournament].tournamentLoosers.laps objectAtIndex:i];
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




-(void)createTournamentFinalistView{
    
    if(self.tournamentFinalistView){
        for( UIView*view in self.tournamentFinalistView.subviews){
            [view removeFromSuperview];
        }
        
        [self.tournamentFinalistView removeFromSuperview];
    }
    
    
    int players =2;
    int laps =2;
    
    int h =(players/2.0)*(UI_MATCH_HEIGT+UI_LINE_HEIGHT);
    int w =laps*(UI_MATCH_WIDTH+UI_LINE_WIDTH);
    
    CGRect rect=CGRectMake(0, 0, w, h);
    
    self.tournamentFinalistView=[[UIView alloc]initWithFrame:rect];
    
    int posY=(rect.size.height-UI_MATCH_HEIGT)/2.0;
    rect =CGRectMake(0, posY, UI_MATCH_WIDTH, UI_MATCH_HEIGT);
    
    SCMatchView *match =[[SCMatchView alloc]initWithFrame:rect];
    match.backgroundColor=[UIColor whiteColor   ];
    match.match =[SC tournament].finalA;
    match.delegate=self;
    [match update];
    [self.tournamentFinalistView addSubview:match];
    
    rect.origin.x += (UI_MATCH_WIDTH+UI_LINE_WIDTH);
    SCMatchView *match2 =[[SCMatchView alloc]initWithFrame:rect];
    match2.backgroundColor=[UIColor whiteColor   ];
    match2.match =[SC tournament].finalB;
    match2.delegate=self;
    [match2 update];
    [self.tournamentFinalistView addSubview:match2];
    
    
    
    
}



-(void)displayTournamentNow{
    
    if(self.tournamentsView){
        [self.tournamentsView removeFromSuperview];
        [self.scrollView removeFromSuperview];
    }
    
    
    
    int players =[SC tournament].tournamentWinners.players.count*1.5;
    int laps =[SC tournament].tournamentLoosers.laps.count +2 ;
    
    int h =((players/2.0)*(UI_MATCH_HEIGT+UI_LINE_HEIGHT)+UI_TOURNAMENTS_VERTICAL_SPACE*2.0);
    int w =laps*(UI_MATCH_WIDTH+UI_LINE_WIDTH)+UI_TOURNAMENTS_HORIZONTAL_SPACE*2.0;
    float minZoom = self.view.bounds.size.height/h;
    
    
    CGRect rect=CGRectMake(0, 0, w, h);
    self.tournamentsView =[[UIView alloc]initWithFrame:rect];
    
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
    [self.scrollView addSubview:self.tournamentsView ];
    
      //  SETUP THE WINNERS TOURNAMENT
    [self createTournamentWinnersView];
    rect =self.tournamentWinnersView.frame;
    rect.origin.y = UI_TOURNAMENTS_VERTICAL_SPACE;
    rect.origin.x+=UI_TOURNAMENTS_HORIZONTAL_SPACE;
    self.tournamentWinnersView.frame=rect;
    [self.tournamentsView addSubview:self.tournamentWinnersView];
    
     //  SETUP THE LOOSERS TOURNAMENT
    [self createTournamentLoosersView];
    rect =self.tournamentLoosersView.frame;
    rect.origin.y = self.tournamentWinnersView.frame.origin.y+self.tournamentWinnersView.frame.size.height+UI_TOURNAMENTS_VERTICAL_SPACE;
    rect.origin.x+=UI_TOURNAMENTS_HORIZONTAL_SPACE;
    self.tournamentLoosersView.frame=rect;
    [self.tournamentsView addSubview:self.tournamentLoosersView];
   
    //  SETUP THE FINALS
    [self createTournamentFinalistView];
    rect =self.tournamentFinalistView.frame;
    rect.origin.x = self.tournamentLoosersView.frame.origin.x+self.tournamentLoosersView.frame.size.width;
    rect.origin.y= (self.tournamentsView.frame.size.height -self.tournamentFinalistView.frame.size.height)/2.0;
    self.tournamentFinalistView.frame=rect;
    [self.tournamentsView addSubview:self.tournamentFinalistView];
    
    
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return  self.tournamentsView;
}

-(void)didTouch:(SCMatchView*)match{
    if(!match.match.state ||
       match.match.finished){
        //PLAYERS ARE UNDEFINED
        return;
    }
    NSString *text=[NSString stringWithFormat:@"%@ or %@",match.match.playerA.name , match.match.playerB.name];
    
    __weak SCMatch *weakMatch=match.match;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Play !"
                                                    message:@"Who should Win?"
                                                   delegate:nil
                                          cancelButtonTitle:match.match.playerA.name
                                          otherButtonTitles:match.match.playerB.name, nil];
    
    [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == [alertView cancelButtonIndex]) {
            
            if(weakMatch.type==MATCH_NORMAL){
                [[SC tournament]setWinner:MATCH_WIN_TEAM_A forWinnerMatch:weakMatch];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayTournamentNow];
                });
            }else if(weakMatch.type==MATCH_LOOSER){
                [[SC tournament]setWinner:MATCH_WIN_TEAM_A forLooserMatch:weakMatch];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayTournamentNow];
                });
            }else{
                [[SC tournament]setWinner:MATCH_WIN_TEAM_A forFinal:weakMatch];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(weakMatch!=[SC tournament].finalB){
                    [self displayTournamentNow];
                    }
                });
            }
            
            
            
        } else {
            
            if(weakMatch.type==MATCH_NORMAL){
                [[SC tournament]setWinner:MATCH_WIN_TEAM_B forWinnerMatch:weakMatch];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayTournamentNow];
                });
            }else if(weakMatch.type==MATCH_LOOSER){
                [[SC tournament]setWinner:MATCH_WIN_TEAM_B forLooserMatch:weakMatch];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayTournamentNow];
                });
            }else{
                [[SC tournament]setWinner:MATCH_WIN_TEAM_B forFinal:weakMatch];
                if(weakMatch!=[SC tournament].finalB){
                    [self displayTournamentNow];
                }
            }
        }
    }];
}
@end
