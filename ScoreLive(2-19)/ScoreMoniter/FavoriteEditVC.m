//
//  FavoriteEditVC.m
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoriteEditVC.h"
#import "TeamListVC.h"
#import "CountryListVC.h"
#import "MatchListVC.h"

@implementation FavoriteEditVC
@synthesize g_Manager;
@synthesize location_lbl, match_lbl, team_lbl, location_code, gn_code, team_code;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    if (countryListVC) {
        [countryListVC release];
        countryListVC = nil;
    }
    
    if (matchListVC) {
        [matchListVC release];
         matchListVC = nil;
    }
    
    if (teamListVC) {
        [teamListVC release];
        teamListVC = nil;
    }
    
    [location_lbl release];
    [match_lbl release];
    [team_lbl release];
    [location_code release];
    [team_code release];
    [gn_code release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
   //NSLog(@"viewDidApear");
    if (g_Manager == nil) {
        g_Manager=(ScoreMoniterAppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    if(g_Manager.bIsFavoriteUpdate == NO)
    {
        NSString *country_str, *match_str, *team_str;
        if(g_Manager.g_Scope == soccer)
        {
            country_str =[g_Manager.g_SoccerSave objectAtIndex:0];
            team_str    =[g_Manager.g_SoccerSave objectAtIndex:1];
            match_str   =[g_Manager.g_SoccerSave objectAtIndex:2];
            location_code =[g_Manager.g_SoccerSave objectAtIndex:3];
            team_code   =[g_Manager.g_SoccerSave objectAtIndex:4];
            gn_code     =[g_Manager.g_SoccerSave objectAtIndex:5];
        }
        else if(g_Manager.g_Scope == basketball)
        {
            country_str =[g_Manager.g_BasketSave objectAtIndex:0];
            team_str    =[g_Manager.g_BasketSave objectAtIndex:1];
            match_str   =[g_Manager.g_BasketSave objectAtIndex:2];
            location_code=[g_Manager.g_BasketSave objectAtIndex:3];
            team_code   =[g_Manager.g_BasketSave objectAtIndex:4];
            gn_code     =[g_Manager.g_BasketSave objectAtIndex:5];
        }
        else if(g_Manager.g_Scope == tennis)
        {
            country_str =[g_Manager.g_TennisSave objectAtIndex:0];
            team_str    =[g_Manager.g_TennisSave objectAtIndex:1];
            match_str   =[g_Manager.g_TennisSave objectAtIndex:2];
            location_code=[g_Manager.g_TennisSave objectAtIndex:3];
            team_code   =[g_Manager.g_TennisSave objectAtIndex:4];
            gn_code     =[g_Manager.g_TennisSave objectAtIndex:5];
        }
        else if(g_Manager.g_Scope == volleyball)
        {
            country_str =[g_Manager.g_VolleySave objectAtIndex:0];
            team_str    =[g_Manager.g_VolleySave objectAtIndex:1];
            match_str   =[g_Manager.g_VolleySave objectAtIndex:2];
            location_code =[g_Manager.g_VolleySave objectAtIndex:3];
            team_code   =[g_Manager.g_VolleySave objectAtIndex:4];
            gn_code     =[g_Manager.g_VolleySave objectAtIndex:5];
        }
        else if(g_Manager.g_Scope == baseball)
        {
            country_str =[g_Manager.g_BaseBSave objectAtIndex:0];
            team_str    =[g_Manager.g_BaseBSave objectAtIndex:1];
            match_str   =[g_Manager.g_BaseBSave objectAtIndex:2];
            location_code=[g_Manager.g_BaseBSave objectAtIndex:3];
            team_code   =[g_Manager.g_BaseBSave objectAtIndex:4];
            gn_code     =[g_Manager.g_BaseBSave objectAtIndex:5];
        }
        else if(g_Manager.g_Scope == hockey)
        {
            country_str =[g_Manager.g_Hockey objectAtIndex:0];
            team_str    =[g_Manager.g_Hockey objectAtIndex:1];
            match_str   =[g_Manager.g_Hockey objectAtIndex:2];
            location_code=[g_Manager.g_Hockey objectAtIndex:3];
            team_code   =[g_Manager.g_Hockey objectAtIndex:4];
            gn_code     =[g_Manager.g_Hockey objectAtIndex:5];
        }
        else
        {
            country_str = NSLocalizedString(@"All Country", @"All Country");
            team_str    = NSLocalizedString(@"All Team", @"All Team");
            match_str   = NSLocalizedString(@"All Match", @"All Match");
        }
        [location_lbl setText:country_str];
        [match_lbl setText:match_str];
        [team_lbl setText:team_str];
        g_Manager.bIsFavoriteUpdate = YES;
    }
}
- (void)viewDidLoad
{
    g_Manager=(ScoreMoniterAppDelegate*)[[UIApplication sharedApplication]delegate];
    self.title = NSLocalizedString(@"favorite",@"Favorite");
    
    UIBarButtonItem *leftbutton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back",@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(CancelFavorite)];
    self.navigationItem.leftBarButtonItem = leftbutton;
    [leftbutton release];  
    
    UIBarButtonItem *rightbutton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done",@"Done") style:UIBarButtonItemStyleBordered target:self action:@selector(SaveFavorite)];
    self.navigationItem.rightBarButtonItem = rightbutton;
    [rightbutton release];  
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark main Functions
- (void)SaveFavorite
{
    NSString *country_str, *match_str, *team_str;
    country_str = [location_lbl text];
    match_str = [match_lbl text];
    team_str = [team_lbl text];
    if(g_Manager.g_Scope == soccer)
    {
        [g_Manager.g_SoccerSave replaceObjectAtIndex:0 withObject:country_str];
        [g_Manager.g_SoccerSave replaceObjectAtIndex:1 withObject:team_str];
        [g_Manager.g_SoccerSave replaceObjectAtIndex:2 withObject:match_str];
        [g_Manager.g_SoccerSave replaceObjectAtIndex:3 withObject:location_code];
        [g_Manager.g_SoccerSave replaceObjectAtIndex:4 withObject:team_code];
        [g_Manager.g_SoccerSave replaceObjectAtIndex:5 withObject:gn_code];
        g_Manager.bIsFavoriteUpdate = NO;
    }
    else if(g_Manager.g_Scope == basketball)
    {
        [g_Manager.g_BasketSave replaceObjectAtIndex:0 withObject:country_str];
        [g_Manager.g_BasketSave replaceObjectAtIndex:1 withObject:team_str];
        [g_Manager.g_BasketSave replaceObjectAtIndex:2 withObject:match_str];
        [g_Manager.g_BasketSave replaceObjectAtIndex:3 withObject:location_code];
        [g_Manager.g_BasketSave replaceObjectAtIndex:4 withObject:team_code];
        [g_Manager.g_BasketSave replaceObjectAtIndex:5 withObject:gn_code];
        g_Manager.bIsFavoriteUpdate = NO;
    }
    else if(g_Manager.g_Scope == tennis)
    {
        [g_Manager.g_TennisSave replaceObjectAtIndex:0 withObject:country_str];
        [g_Manager.g_TennisSave replaceObjectAtIndex:1 withObject:team_str];
        [g_Manager.g_TennisSave replaceObjectAtIndex:2 withObject:match_str];
        [g_Manager.g_TennisSave replaceObjectAtIndex:3 withObject:location_code];
        [g_Manager.g_TennisSave replaceObjectAtIndex:4 withObject:team_code];
        [g_Manager.g_TennisSave replaceObjectAtIndex:5 withObject:gn_code];
        g_Manager.bIsFavoriteUpdate = NO;
    }
    else if(g_Manager.g_Scope == volleyball)
    {
        [g_Manager.g_VolleySave replaceObjectAtIndex:0 withObject:country_str];
        [g_Manager.g_VolleySave replaceObjectAtIndex:1 withObject:team_str];
        [g_Manager.g_VolleySave replaceObjectAtIndex:2 withObject:match_str];
        [g_Manager.g_VolleySave replaceObjectAtIndex:3 withObject:location_code];
        [g_Manager.g_VolleySave replaceObjectAtIndex:4 withObject:team_code];
        [g_Manager.g_VolleySave replaceObjectAtIndex:5 withObject:gn_code];
        g_Manager.bIsFavoriteUpdate = NO;
    }
    else if(g_Manager.g_Scope == baseball)
    {
        [g_Manager.g_BaseBSave replaceObjectAtIndex:0 withObject:country_str];
        [g_Manager.g_BaseBSave replaceObjectAtIndex:1 withObject:team_str];
        [g_Manager.g_BaseBSave replaceObjectAtIndex:2 withObject:match_str];
        [g_Manager.g_BaseBSave replaceObjectAtIndex:3 withObject:location_code];
        [g_Manager.g_BaseBSave replaceObjectAtIndex:4 withObject:team_code];
        [g_Manager.g_BaseBSave replaceObjectAtIndex:5 withObject:gn_code];
        g_Manager.bIsFavoriteUpdate = NO;
    }
    else if(g_Manager.g_Scope == hockey)
    {
        [g_Manager.g_Hockey replaceObjectAtIndex:0 withObject:country_str];
        [g_Manager.g_Hockey replaceObjectAtIndex:1 withObject:team_str];
        [g_Manager.g_Hockey replaceObjectAtIndex:2 withObject:match_str];
        [g_Manager.g_Hockey replaceObjectAtIndex:3 withObject:location_code];
        [g_Manager.g_Hockey replaceObjectAtIndex:4 withObject:team_code];
        [g_Manager.g_Hockey replaceObjectAtIndex:5 withObject:gn_code];
        g_Manager.bIsFavoriteUpdate = NO;        
    }
    else
    {
        g_Manager.bIsFavoriteUpdate = NO;   
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)CancelFavorite
{
    g_Manager.bIsFavoriteUpdate = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onLocation
{
    if (countryListVC == nil) {
        countryListVC = [[CountryListVC alloc] initWithNibName:@"CountryListVC" bundle:[NSBundle mainBundle]]; 
    }
    countryListVC.favoriteVC = self;
    [self.navigationController pushViewController:countryListVC animated:YES];

}
- (IBAction)onMatch
{
    if (matchListVC == nil) {
        matchListVC = [[MatchListVC alloc] initWithNibName:@"MatchListVC" bundle:[NSBundle mainBundle]]; 
    }
    matchListVC.favoriteVC = self;
    [self.navigationController pushViewController:matchListVC animated:YES];
    
}
- (IBAction)onTeam
{
    if (teamListVC == nil) {
        teamListVC = [[TeamListVC alloc] initWithNibName:@"TeamListVC" bundle:[NSBundle mainBundle]]; 
    }
    teamListVC.favoriteVC = self;
    [self.navigationController pushViewController:teamListVC animated:YES];
}

@end
