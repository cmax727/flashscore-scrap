//
//  FavoriteEditVC.h
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreMoniterAppDelegate.h"
@class CountryListVC;
@class MatchListVC;
@class TeamListVC;

@interface FavoriteEditVC : UIViewController {

    ScoreMoniterAppDelegate *g_Manager;
    UILabel                 *location_lbl, *match_lbl, *team_lbl, *timezone_lbl;  
    NSString                *location_code, *gn_code, *team_code;
    
    CountryListVC           *countryListVC;
    MatchListVC             *matchListVC;
    TeamListVC              *teamListVC;
}
@property (nonatomic, retain) ScoreMoniterAppDelegate *g_Manager;
@property (nonatomic, retain) IBOutlet UILabel *location_lbl, *match_lbl, *team_lbl;
@property (nonatomic, retain) NSString *location_code, *gn_code, *team_code;

- (IBAction)onLocation;
- (IBAction)onMatch;
- (IBAction)onTeam;

- (void)SaveFavorite;
- (void)CancelFavorite;
@end
