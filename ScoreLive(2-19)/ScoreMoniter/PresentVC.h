//
//  PresentVC.h
//  ScoreMoniter
//
//  Created by yincheng on 12/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentVC : UIViewController {
    UILabel *match_lbl, *teamA_lbl, *teamB_lbl, *local_time_lbl;
    UILabel *scoreA1_lbl, *scoreB1_lbl, *scoreA2_lbl, *scoreB2_lbl, *scoreA3_lbl, *scoreB3_lbl, *scoreA4_lbl, *scoreB4_lbl, *scoreA5_lbl, *scoreB5_lbl;
    UIImageView *m_ImgState, *m_Img1, *m_Img2, *m_Img3, *m_Img4, *m_Imglink;//Game-Time, Game-State
    UIImageView *m_ImgRound, *m_BigA_1, *m_BigA_2, *m_BigA_3, *m_BigB_1, *m_BigB_2, *m_BigB_3;//Total Game Score
    NSInteger m_countPos;
    NSInteger g_type;
    NSString        *host, *g_code, *gn_name, *teamA, *teamB; //Game-ID
    NSTimeInterval  refreshDelay;
    NSInteger       m_countryID;
    UIImage         *flagsImg;
    UIImageView     *m_Imgbg;
    UIImageView     *countryImgView;
    
    NSMutableArray  *result;
    NSTimeInterval  lastUpdated;
    NSInteger       nTimeZone;
    
    Boolean         bIsActived;
  	NSThread        *m_thread;
    
    //run_time
    NSTimer         *nsTimer;
    NSString        *g_time;
    long            game_time;
    BOOL            bLighted;
    NSDictionary    *round_names;
}
@property NSInteger m_countryID;
@property (nonatomic) NSTimeInterval refreshDelay;
@property (nonatomic) NSInteger nTimeZone, g_type;
@property (retain) NSTimer *nsTimer;
@property (nonatomic, retain) NSString *host, *g_code, *gn_name, *teamA, *teamB;

@property (nonatomic, retain) IBOutlet UIImageView *m_Imgbg, *countryImgView;
@property (nonatomic, retain) IBOutlet UIImageView *m_ImgState, *m_Img1, *m_Img2, *m_Img3, *m_Img4, *m_Imglink;
@property (nonatomic, retain) IBOutlet UIImageView *m_ImgRound, *m_BigA_1, *m_BigA_2, *m_BigA_3, *m_BigB_1, *m_BigB_2, *m_BigB_3;

@property (nonatomic, retain) NSMutableArray *result;

@property (nonatomic, retain) IBOutlet UILabel *match_lbl, *teamA_lbl, *teamB_lbl, *local_time_lbl;
@property (nonatomic, retain) IBOutlet UILabel *scoreA1_lbl, *scoreB1_lbl, *scoreA2_lbl, *scoreB2_lbl, *scoreA3_lbl, *scoreB3_lbl, *scoreA4_lbl, *scoreB4_lbl, *scoreA5_lbl, *scoreB5_lbl;


//Main Function
- (void)onClickBack:(id)Sender;
- (void)tick;
- (void)refresh;
- (void)timeDisplay;
- (void)liveDisplay;
- (void)StateDisplay;
- (void)setCurrentGameTime;
- (void)setCurrentRound:(NSString *)round;
- (void)setCurTotalScore:(NSInteger)nPosCount nScoreA:(NSString *)scoreA nScoreB:(NSString *)scoreB;
@end
