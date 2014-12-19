//
//  ScoreMoniterAppDelegate.h
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LodingVC;

@interface ScoreMoniterAppDelegate : NSObject <UIApplicationDelegate> {
    NSInteger g_Scope;         //"soccer", "basketball",...
    NSMutableArray *g_SoccerSave, *g_BasketSave, *g_TennisSave, *g_VolleySave, *g_BaseBSave, *g_Hockey;  //"key-location, country, team, match"
    NSString   *soccer_state, *basketball_state, *volleyball_state, *tennis_state, *hockey_state, *baseball_state;
    Boolean bIsFavoriteUpdate;
    NSTimeInterval delay;
    NSInteger nTimeZone;
    NSString *host;
    
    UIWindow *window;
    LodingVC *startViewController;
	UINavigationController *mainNavigationController;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LodingVC *startViewController;
@property Boolean bIsFavoriteUpdate;
@property NSTimeInterval delay;
@property NSInteger nTimeZone;
@property (nonatomic, retain) NSString *soccer_state, *basketball_state, *volleyball_state, *tennis_state, *hockey_state, *baseball_state, *host;
@property (nonatomic, readwrite) NSInteger g_Scope;
@property (nonatomic, retain) NSMutableArray *g_SoccerSave, *g_BasketSave, *g_TennisSave, *g_VolleySave, *g_BaseBSave, *g_Hockey; 

@property (nonatomic, retain) IBOutlet UINavigationController *mainNavigationController;

- (void)enterMenuView;
- (void)getFaoviteFromPhone;
- (void)saveFavoriteToPhone;
@end

#define soccer 1
#define tennis 2
#define basketball 3
#define hockey 4
#define baseball 6
#define handball 7
#define volleyball 12