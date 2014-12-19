//
//  MainMenuVC.m
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuVC.h"
#import "SoccerVC.h"

#define BIGRECT CGRectMake(0.0f, 151.0f, 320.0f, 329.0f)
#define SMALLRECT CGRectMake(0.0f, 220.0f, 240.0f, 260.0f)

@implementation MainMenuVC
@synthesize slide1_Img, slide2_Img,m_lightImg, nsTimer, soccer_btn, basketball_btn, volleyball_btn, baseball_btn, hockey_btn, tennis_btn, soccerVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
//  if (g_Manager)
//  {
//    [g_Manager release];
//    g_Manager = nil;
//  }
    if (nsTimer) {
        [nsTimer release];
        nsTimer = nil;
    }
    if (soccerVC) {
        [soccerVC release];
        soccerVC = nil;
    }
    [slide1_Img release];
    [slide2_Img release];
    [m_lightImg release];
    
    [soccer_btn release];
    [basketball_btn release];
    [volleyball_btn release];
    [baseball_btn   release];
    [hockey_btn     release];
    [tennis_btn     release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
	//[[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self viewDidLoad];
}
- (void)viewWillDisappear:(BOOL)animated
{
	//[[UIApplication sharedApplication] setStatusBarHidden:NO];
//    if (nsTimer) {
//        [nsTimer invalidate];
//        nsTimer = nil;
//    }
    //[m_lightImg stopAnimating];
}
- (void)viewDidLoad
{
    
    if (g_Manager == nil) {
        g_Manager=(ScoreMoniterAppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES];
    if (nsTimer == nil) {
        nImgSwitch = 1;
        isImgCur = false;
        nsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(SwapBackground) userInfo:nil repeats:YES];
    }
    //Star Light Effect 
    NSMutableArray *bflies = [[NSMutableArray alloc] init];
	for (int i = 0; i <= 28; i++) {
		NSString *cname = [NSString stringWithFormat:@"p%d.png", i];
		UIImage *img = [UIImage imageNamed:cname];
		if (img) [bflies addObject:img];
	}
    [m_lightImg setAnimationImages:bflies];
	[m_lightImg setAnimationDuration:1.5f];
	[m_lightImg startAnimating];
	[bflies release];
    
    
    if (soccer_btn) {
        [soccer_btn addTarget:self action:@selector(onSoccerClick:) forControlEvents:UIControlEventTouchDown];
    }
    if (basketball_btn) {
        [basketball_btn addTarget:self action:@selector(onBasketBallClick:) forControlEvents:UIControlEventTouchDown];
    }
    if (volleyball_btn) {
        [volleyball_btn addTarget:self action:@selector(onVolleyBallClick:) forControlEvents:UIControlEventTouchDown];
    }
    if (baseball_btn) {
        [baseball_btn addTarget:self action:@selector(onBaseBallClick:) forControlEvents:UIControlEventTouchDown];
    }
    if (hockey_btn) {
        [hockey_btn addTarget:self action:@selector(onHockeyClick:) forControlEvents:UIControlEventTouchDown];
    }
    if (tennis_btn) {
        [tennis_btn addTarget:self action:@selector(onTennisClick:) forControlEvents:UIControlEventTouchDown];
    }    
    if (soccerVC == nil)
        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:nil];
}
- (void)SwapBackground
{
    
    NSString *ImgName = [[NSString alloc] initWithFormat:@"f%d.png", nImgSwitch];
    UIImageView *big, *little;
    if (isImgCur == true) {
        [slide1_Img setImage:[UIImage imageNamed:ImgName]];
        big = slide2_Img;
        little = slide1_Img;
    }
    else
    {
        [slide2_Img setImage:[UIImage imageNamed:ImgName]];
        little = slide2_Img;
        big = slide1_Img;
    }
    isImgCur = !isImgCur;
	
	// Pack all the changes into the animation block
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.2];
    
	[big setFrame:SMALLRECT];
	[big setAlpha:0.5];
	[little setFrame:BIGRECT];
	[little setAlpha:1.0];
	
	[UIView commitAnimations];
	
	// Hide the shrunken "big" image.
	[big setAlpha:0.0f];
	//[[big superview] bringSubviewToFront:big];
    
    //StarLight Effect
    CGFloat nX = nImgSwitch*50 + 96;
    [m_lightImg setFrame:CGRectMake(166, nX, 50, 50)];
    
    nImgSwitch++;
    if (nImgSwitch>6) {
        nImgSwitch = 1;
    }
}

- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) onSoccerClick:(id)sender {
    g_Manager.g_Scope = soccer;
    g_Manager.bIsFavoriteUpdate = NO;
    
    if (soccerVC == nil)
        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:nil];
    soccerVC.title = NSLocalizedString(@"soccer",@"Soccer");
    [self.navigationController pushViewController:soccerVC animated:YES];
}
- (void) onBasketBallClick:(id)sender {
    g_Manager.g_Scope = basketball;
    g_Manager.bIsFavoriteUpdate = NO;
    if (soccerVC == nil)
        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:nil];
    soccerVC.title = NSLocalizedString(@"basketball",@"BasketBall");
    [self.navigationController pushViewController:soccerVC animated:YES];
}

- (void) onVolleyBallClick:(id)sender {
    g_Manager.g_Scope = volleyball;
    g_Manager.bIsFavoriteUpdate = NO;
    if (soccerVC == nil)
        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:nil];
     soccerVC.title = NSLocalizedString(@"volleyball",@"VolleyBall");
    [self.navigationController pushViewController:soccerVC animated:YES];
}
- (void) onBaseBallClick:(id)sender {
    g_Manager.g_Scope = baseball;
    g_Manager.bIsFavoriteUpdate = NO;
    if (soccerVC == nil)
        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:nil];
    soccerVC.title = NSLocalizedString(@"baseball",@"BaseBall");
    [self.navigationController pushViewController:soccerVC animated:YES];
}
- (void) onHockeyClick:(id)sender {
    g_Manager.g_Scope = hockey;
    g_Manager.bIsFavoriteUpdate = NO;
    if (soccerVC == nil)
        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:nil];
    soccerVC.title = NSLocalizedString(@"hockey",@"Hockey");
    [self.navigationController pushViewController:soccerVC animated:YES];
}
- (void) onTennisClick:(id)sender {
    g_Manager.g_Scope = tennis;
    g_Manager.bIsFavoriteUpdate = NO;
    if (soccerVC == nil)
        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:nil];
    soccerVC.title = NSLocalizedString(@"tennis",@"Tennis");
    [self.navigationController pushViewController:soccerVC animated:YES];
}
@end
