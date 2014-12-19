//
//  TimeZoneVC.h
//  ScoreMoniter
//
//  Created by yincheng on 12/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreMoniterAppDelegate.h"

@class SoccerVC;
@interface TimeZoneVC : UIViewController <UIPickerViewDelegate, UITextFieldDelegate>
{
    ScoreMoniterAppDelegate *g_Manager;
    SoccerVC    *soccerVC;
    UILabel     *server, *update, *timezone;
    UILabel     *curTime_lbl, *curGMT_lbl, *Delay_lbl;
    UITextField *Host_lbl;
    NSInteger   nGMT, nDelay;
    UIPickerView *pickerView;
    UISlider     *silder;
}
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) SoccerVC  *soccerVC;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UILabel *server, *update, *timezone;
@property (nonatomic, retain) IBOutlet UILabel *curTime_lbl, *curGMT_lbl, *Delay_lbl;
@property (nonatomic, retain) IBOutlet UITextField *Host_lbl;
- (void)Cancel:(id)sender;
- (void)Apply:(id)sender;
- (void)UpdateDelay:(id)sender;
@end
