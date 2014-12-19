//
//  MainMenuVC.h
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreMoniterAppDelegate.h"

@class SoccerVC;

@interface MainMenuVC : UIViewController {
    SoccerVC                *soccerVC;
    ScoreMoniterAppDelegate *g_Manager;
    //Buttons
    UIButton                *soccer_btn, *basketball_btn, *volleyball_btn, *baseball_btn, *hockey_btn, *tennis_btn;
    //Star Light 
    UIImageView             *m_lightImg;
    
    //Image Slide Effect
    UIImageView             *slide1_Img, *slide2_Img;
    NSTimer                 *nsTimer;
    NSInteger               nImgSwitch;
    BOOL                    isImgCur;
}
@property (nonatomic, retain) SoccerVC *soccerVC;
@property (nonatomic, retain) IBOutlet UIImageView *slide1_Img, *slide2_Img, *m_lightImg;
@property (nonatomic, retain) IBOutlet UIButton *soccer_btn, *basketball_btn, *volleyball_btn, *baseball_btn, *hockey_btn, *tennis_btn;
@property (retain) NSTimer *nsTimer;


- (void) onSoccerClick:(id)sender;
- (void) onBasketBallClick:(id)sender;
- (void) onVolleyBallClick:(id)sender;
- (void) onBaseBallClick:(id)sender;
- (void) onHockeyClick:(id)sender;
- (void) onTennisClick:(id)sender;

@end
