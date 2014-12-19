//
//  CustomCellVC.m
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell
@synthesize team1, score1, team2, score2, start_time, gmt;
@synthesize status_Img;

- (void)dealloc
{
    [team1 release];
    [score1 release];
    [team2 release];
    [score2 release];
    [status_Img release];
    [start_time release];
    [gmt release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
