//
//  CustomCellVC.h
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell :UITableViewCell {
    IBOutlet UILabel * team1;
    IBOutlet UILabel * team2;
    IBOutlet UILabel * score1;
    IBOutlet UILabel * score2;
    IBOutlet UILabel * start_time;
    IBOutlet UILabel * gmt;
    IBOutlet UIImageView * status_Img;
}
@property (nonatomic, retain) IBOutlet UILabel * start_time, *gmt;
@property (nonatomic, retain) IBOutlet UILabel * team1;
@property (nonatomic, retain) IBOutlet UILabel * team2;
@property (nonatomic, retain) IBOutlet UILabel * score1;
@property (nonatomic, retain) IBOutlet UILabel * score2;
@property (nonatomic, retain) IBOutlet UIImageView * status_Img;

@end
