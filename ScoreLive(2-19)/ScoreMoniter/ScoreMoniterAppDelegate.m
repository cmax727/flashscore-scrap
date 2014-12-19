//
//  ScoreMoniterAppDelegate.m
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreMoniterAppDelegate.h"
#import "LodingVC.h"

@implementation ScoreMoniterAppDelegate

@synthesize window;
@synthesize mainNavigationController,startViewController, host, delay;
@synthesize g_SoccerSave, g_BasketSave, g_VolleySave, g_TennisSave, g_BaseBSave, g_Hockey, g_Scope, nTimeZone; 
@synthesize bIsFavoriteUpdate, soccer_state, basketball_state, volleyball_state, tennis_state, hockey_state, baseball_state;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
   	//[[UIApplication sharedApplication] setStatusBarHidden:YES];
    window.rootViewController = mainNavigationController;
    
	[window addSubview:mainNavigationController.view];
    [window addSubview:startViewController.view];
	//mainNavigationController.view.alpha = 0.0;
    [self getFaoviteFromPhone];
    [window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self saveFavoriteToPhone];

}

- (void)dealloc
{
    [g_SoccerSave release];
    [g_BasketSave release];
    [g_VolleySave release];
    [g_BaseBSave release];
    [g_Hockey release];
    [g_TennisSave release];
    [window release];
    [mainNavigationController release];
    [super dealloc];
}

- (void)enterMenuView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	startViewController.view.alpha = 0.0;
	mainNavigationController.view.alpha = 1.0;
	[UIView commitAnimations];
}
- (void)saveFavoriteToPhone
{
    if (g_SoccerSave) {
        [[NSUserDefaults standardUserDefaults] setObject:g_SoccerSave forKey:@"soccer"];
    }
    if (g_BasketSave) {
        [[NSUserDefaults standardUserDefaults] setObject:g_BasketSave forKey:@"basketball"];
    }
    if (g_VolleySave) {
        [[NSUserDefaults standardUserDefaults] setObject:g_VolleySave forKey:@"volleyball"];
    }
    if (g_BaseBSave) {
        [[NSUserDefaults standardUserDefaults] setObject:g_BaseBSave forKey:@"baseball"];
    }
    if (g_TennisSave) {
        [[NSUserDefaults standardUserDefaults] setObject:g_TennisSave forKey:@"tennis"];
    }
    if (g_Hockey) {
        [[NSUserDefaults standardUserDefaults] setObject:g_Hockey forKey:@"hockey"];
    }

    if (host == nil) {
        //host= @"tampabaycommercialspace.com/index.php";
        //host = @"192.168.0.41/ssc/iphone_proxy.php";
        host = @"175.41.29.18";
    }
    if (delay == 0) {
        delay = 5;
    }
    NSDictionary *systemSave = [[NSDictionary alloc] initWithObjectsAndKeys:host, @"host", delay, @"delay", nTimeZone, @"timezone", nil];
    [[NSUserDefaults standardUserDefaults] setObject:systemSave forKey:@"system"];

}

- (void)getFaoviteFromPhone{
    //Keys:team, match, location
   
    g_SoccerSave = [[NSUserDefaults standardUserDefaults] objectForKey:@"soccer"];
    g_BasketSave = [[NSUserDefaults standardUserDefaults] objectForKey:@"basketball"];
    g_VolleySave = [[NSUserDefaults standardUserDefaults] objectForKey:@"volleyball"];
    g_BaseBSave = [[NSUserDefaults standardUserDefaults] objectForKey:@"baseball"];
    g_Hockey = [[NSUserDefaults standardUserDefaults] objectForKey:@"hockey"];
    g_TennisSave = [[NSUserDefaults standardUserDefaults] objectForKey:@"tennis"];
    NSDictionary *systemSave = [[NSUserDefaults standardUserDefaults] objectForKey:@"system"];  
    
    if (g_SoccerSave == nil) {
        g_SoccerSave = [[NSMutableArray alloc] initWithCapacity:7];
        [g_SoccerSave addObject:NSLocalizedString(@"All Country", @"All Country")];
        [g_SoccerSave addObject:NSLocalizedString(@"All Team", @"All Team")];
        [g_SoccerSave addObject:NSLocalizedString(@"All Match", @"All Match")];
        [g_SoccerSave addObject:@"%"];
        [g_SoccerSave addObject:@"%"];
        [g_SoccerSave addObject:@"%"];
        [g_SoccerSave addObject:@""];
    }
    if (g_BasketSave == nil) {
        g_BasketSave = [[NSMutableArray alloc] initWithCapacity:7];
        [g_BasketSave addObject:NSLocalizedString(@"All Country", @"All Country")];
        [g_BasketSave addObject:NSLocalizedString(@"All Team", @"All Team")];
        [g_BasketSave addObject:NSLocalizedString(@"All Match", @"All Match")];
        [g_BasketSave addObject:@"%"];
        [g_BasketSave addObject:@"%"];
        [g_BasketSave addObject:@"%"];
        [g_BasketSave addObject:@""];
    }
    if (g_VolleySave == nil) {
        g_VolleySave = [[NSMutableArray alloc] initWithCapacity:7];
        [g_VolleySave addObject:NSLocalizedString(@"All Country", @"All Country")];
        [g_VolleySave addObject:NSLocalizedString(@"All Team", @"All Team")];
        [g_VolleySave addObject:NSLocalizedString(@"All Match", @"All Match")];
        [g_VolleySave addObject:@"%"];
        [g_VolleySave addObject:@"%"];
        [g_VolleySave addObject:@"%"];
        [g_VolleySave addObject:@""];
    }
    if (g_BaseBSave == nil) {
        g_BaseBSave = [[NSMutableArray alloc] initWithCapacity:7];
        [g_BaseBSave addObject:NSLocalizedString(@"All Country", @"All Country")];
        [g_BaseBSave addObject:NSLocalizedString(@"All Team", @"All Team")];
        [g_BaseBSave addObject:NSLocalizedString(@"All Match", @"All Match")];
        [g_BaseBSave addObject:@"%"];
        [g_BaseBSave addObject:@"%"];
        [g_BaseBSave addObject:@"%"];
        [g_BaseBSave addObject:@""];
    }
    if (g_Hockey == nil) {
        g_Hockey = [[NSMutableArray alloc] initWithCapacity:7];
        [g_Hockey addObject:NSLocalizedString(@"All Country", @"All Country")];
        [g_Hockey addObject:NSLocalizedString(@"All Team", @"All Team")];
        [g_Hockey addObject:NSLocalizedString(@"All Match", @"All Match")];
        [g_Hockey addObject:@"%"];
        [g_Hockey addObject:@"%"];
        [g_Hockey addObject:@"%"];
        [g_Hockey addObject:@""];
    }
    if (g_TennisSave == nil) {
        g_TennisSave = [[NSMutableArray alloc] initWithCapacity:7];
        [g_TennisSave addObject:NSLocalizedString(@"All Country", @"All Country")];
        [g_TennisSave addObject:NSLocalizedString(@"All Team", @"All Team")];
        [g_TennisSave addObject:NSLocalizedString(@"All Match", @"All Match")];
        [g_TennisSave addObject:@"%"];
        [g_TennisSave addObject:@"%"];
        [g_TennisSave addObject:@"%"];
        [g_TennisSave addObject:@""];
    }
    if (systemSave) {
        host = [systemSave objectForKey:@"host"];
        delay = [[systemSave objectForKey:@"delay"] integerValue];
        nTimeZone = [[systemSave objectForKey:@"timezone"] integerValue];
    }
    else
    {
        //host = @"tampabaycommercialspace.com/index.php";
        //host = @"192.168.0.41/ssc/iphone_proxy.php";
        host = @"175.41.29.18";
        delay = 5;
        nTimeZone = 0;
    }
    soccer_state=@"%";
    basketball_state=@"%";
    volleyball_state=@"%";
    baseball_state=@"%";
    hockey_state=@"%";
    tennis_state=@"%";
}

@end
