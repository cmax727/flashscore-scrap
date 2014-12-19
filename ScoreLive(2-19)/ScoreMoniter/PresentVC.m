#import "PresentVC.h"
#import "JSON.h"
#import "CJSONDeserializer.h"
#import "ImageCrop.h"
#import "ScoreMoniterAppDelegate.h"

@implementation PresentVC

@synthesize result, nTimeZone, g_code, g_type, gn_name, m_countryID, m_Imgbg, m_ImgState, m_Img1, m_Img2, m_Img3, m_Img4, m_Imglink, countryImgView,m_ImgRound, m_BigA_1, m_BigA_2, m_BigA_3, m_BigB_1, m_BigB_2, m_BigB_3, host, refreshDelay, teamA, teamB;

@synthesize match_lbl, teamA_lbl, teamB_lbl, local_time_lbl;
@synthesize scoreA1_lbl, scoreB1_lbl, scoreA2_lbl, scoreB2_lbl, scoreA3_lbl, scoreB3_lbl, scoreA4_lbl, scoreB4_lbl, scoreA5_lbl, scoreB5_lbl;

@synthesize nsTimer;


#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    //ScoreBoard Active
    [m_BigA_1 setHidden:YES];
    [m_BigA_2 setHidden:YES];
    [m_BigA_3 setHidden:YES];
    [m_BigB_1 setHidden:YES];
    [m_BigB_2 setHidden:YES];
    [m_BigB_3 setHidden:YES];
    
    NSString *bg = [NSString stringWithFormat:@"%d.png", g_type];
    [m_Imgbg setImage:[UIImage imageNamed:bg]];
    [match_lbl setText:gn_name];
    [teamA_lbl setText:teamA];
    [teamB_lbl setText:teamB];
    m_countPos = -1;
}
- (void)onClickBack:(id)Sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"round_name" ofType:@"plist"];
    
    round_names = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back",@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(onClickBack:)];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
    
    if (flagsImg == nil) {
        flagsImg = [UIImage imageNamed:@"flags.png"];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    flagsImg = [UIImage imageNamed:@"flags.png"];
    [countryImgView setImage:[flagsImg getContryImg:m_countryID]];
    
    bIsActived = NO;
    game_time = 0;  //game 'Time'
    bLighted = NO;  //'Time' Image blink or not
    
    NSString *strurl = [NSString stringWithFormat:@"http://%@?table=7&g_code=%@&updated=0",host, g_code];
    //NSLog(@"Present Url:%@", strurl);
    strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *jsonURL = [NSURL URLWithString:strurl];
	NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL encoding:NSUTF8StringEncoding error:nil];
    NSArray  *response = [jsonData componentsSeparatedByString:@"#:#"];    
    if ([response count] == 2) {
        
        lastUpdated = [[response objectAtIndex:0] integerValue];
        result = [[[response objectAtIndex:1] JSONValue] mutableCopy];  
    }
    
    if (result == nil || [result count]==0) {
        bIsActived = NO;
        return;
    }
  
  
    NSDictionary *m_result = [result objectAtIndex:0];
    
   
    //Static Data
    //[teamA_lbl setText:[m_result objectForKey:@"teamA"]];
    //[teamB_lbl setText:[m_result objectForKey:@"teamB"]];
    

    g_time = [m_result objectForKey:@"g_time"];
    
    NSInteger   startTime = [g_time integerValue] + (nTimeZone*3600);
    NSDate *StartDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setTimeStyle:NSDateFormatterShortStyle];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time_str = [dateFormat stringFromDate:StartDate];
    [dateFormat release];
    dateFormat = nil;
    
    NSString *curGMT = [NSString stringWithFormat:@"%@%d",(nTimeZone>-1) ? @"GMT+":@"GMT", nTimeZone];
    time_str = [NSString stringWithFormat:@"%@  %@", time_str, curGMT];
    
    [local_time_lbl setText:time_str];
    
    if ([[m_result objectForKey:@"s0"] isEqual:@"1"]) {
        //Schedule 
        [m_BigA_2 setHidden:NO];
        [m_BigB_2 setHidden:NO];
        [self setCurTotalScore:0 nScoreA:@"0" nScoreB:@"0"];

        [scoreA1_lbl setText:@""];
        [scoreA2_lbl setText:@""];
        [scoreA3_lbl setText:@""];
        [scoreA4_lbl setText:@""];
        [scoreA5_lbl setText:@""];
       
        [scoreB1_lbl setText:@""];
        [scoreB2_lbl setText:@""];
        [scoreB3_lbl setText:@""];
        [scoreB4_lbl setText:@""];
        [scoreB5_lbl setText:@""];
        
        [m_Imglink setHidden:YES];
        [m_Img1 setHidden:YES];
        [m_Img2 setHidden:YES];
        [m_Img3 setHidden:YES];
        [m_Img4 setHidden:YES];
        
        [m_ImgRound setImage:[UIImage imageNamed:@"m-.png"]];
        [m_ImgState setHidden:NO];
        [m_ImgState setImage:[UIImage imageNamed:@"s_schedule.png"]];
        [m_ImgState setAlpha:0.0f];
        bLighted = NO;
        game_time = 0;
        
        if (nsTimer == nil) {
            [self StateDisplay];
            nsTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(StateDisplay) userInfo:nil repeats:YES];
        }
        return;
    } 
    
    [m_BigA_2 setFrame:CGRectMake(78, 138, 29, 42)];
    [m_BigB_2 setFrame:CGRectMake(219, 138, 29, 42)];
    NSInteger scope = [[m_result objectForKey:@"g_type"] integerValue];
    if (scope == soccer || scope == hockey) 
    {
        [m_BigA_1 setHidden:NO];
        [m_BigA_2 setHidden:NO];
        [m_BigB_1 setHidden:NO];
        [m_BigB_2 setHidden:NO];
        m_countPos = 2;
    }
    else if (scope == baseball) {
        [m_BigA_1 setFrame:CGRectMake(60, 138, 29, 42)];
        [m_BigB_1 setFrame:CGRectMake(204, 138, 29, 42)];
        [m_BigA_2 setFrame:CGRectMake(88, 138, 29, 42)];
        [m_BigB_2 setFrame:CGRectMake(229, 138, 29, 42)];
        [m_BigA_1 setHidden:NO];
        [m_BigA_2 setHidden:NO];
        [m_BigB_1 setHidden:NO];
        [m_BigB_2 setHidden:NO];
        m_countPos = 2;
    }
    else if (scope == basketball) {
        [m_BigA_2 setFrame:CGRectMake(66, 138, 29, 42)];
        [m_BigB_2 setFrame:CGRectMake(211, 138, 29, 42)];
        [m_BigA_1 setHidden:NO];
        [m_BigA_2 setHidden:NO];
        [m_BigA_3 setHidden:NO];
        [m_BigB_1 setHidden:NO];
        [m_BigB_2 setHidden:NO];
        [m_BigB_3 setHidden:NO];
        m_countPos = 3;
    }
    else
    {
        [m_BigA_1 setHidden:YES];
        [m_BigA_2 setHidden:NO];
        [m_BigA_3 setHidden:YES];
        [m_BigB_1 setHidden:YES];
        [m_BigB_2 setHidden:NO];
        [m_BigB_3 setHidden:YES];
        m_countPos = 1;
    }
    if ([[m_result objectForKey:@"s0"] isEqual:@"2"]) {
        //Live
        bIsActived  = YES;
        //Round
        NSString *strRound = [round_names objectForKey:[m_result objectForKey:@"s1"]];
        [self setCurrentRound:strRound];
    }
    if ([[m_result objectForKey:@"s0"] isEqual:@"3"]) {
        //Finish
        [m_Imglink setHidden:YES];
        [m_Img1 setHidden:YES];
        [m_Img2 setHidden:YES];
        [m_Img3 setHidden:YES];
        [m_Img4 setHidden:YES];
        [m_ImgState setHidden:NO];
        
        
        if ([[m_result objectForKey:@"s1"] isEqual:@"3"]) {
            [m_ImgState setImage:[UIImage imageNamed:@"s_finished.png"]];
        }
        else if ([[m_result objectForKey:@"s1"] isEqual:@"4"]) {
            [m_ImgState setImage:[UIImage imageNamed:@"s_postponed.png"]];
        }
        else if ([[m_result objectForKey:@"s1"] isEqual:@"5"]) {
            [m_ImgState setImage:[UIImage imageNamed:@"s_canceled.png"]];
        }
        else if ([[m_result objectForKey:@"s1"] isEqual:@"9"]) {
            [m_ImgState setImage:[UIImage imageNamed:@"s_walkover.png"]];
        }
        else if ([[m_result objectForKey:@"s1"] isEqual:@"10"]) {
            [m_ImgState setImage:[UIImage imageNamed:@"s_afterET.png"]];
        }
        else {
            [m_ImgState setImage:[UIImage imageNamed:@"s_finished.png"]];
        }
        
        //Round
        [self setCurrentRound:@"-"];
        
        [m_ImgState setAlpha:0.0f];
        bLighted = NO;
        game_time = 0;
        if (nsTimer == nil) {
            [self StateDisplay];
            nsTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(StateDisplay) userInfo:nil repeats:YES];
        }
    }
    //Total Score
    [self setCurTotalScore:m_countPos nScoreA:[m_result objectForKey:@"a0"] nScoreB:[m_result objectForKey:@"b0"]];
    
    [scoreA1_lbl setText:[m_result objectForKey:@"a1"]];
    [scoreA2_lbl setText:[m_result objectForKey:@"a2"]];
    [scoreA3_lbl setText:[m_result objectForKey:@"a3"]];
    [scoreA4_lbl setText:[m_result objectForKey:@"a4"]];
    [scoreA5_lbl setText:[m_result objectForKey:@"a5"]];
    
    [scoreB1_lbl setText:[m_result objectForKey:@"b1"]];
    [scoreB2_lbl setText:[m_result objectForKey:@"b2"]];
    [scoreB3_lbl setText:[m_result objectForKey:@"b3"]];
    [scoreB4_lbl setText:[m_result objectForKey:@"b4"]];
    [scoreB5_lbl setText:[m_result objectForKey:@"b5"]];
    
    //NSLog(@"Present---LoadMyData!");
    if (bIsActived==YES)
    {
        [self setCurrentGameTime];
        if ([[m_result objectForKey:@"g_type"] integerValue] == soccer)
        {
                [m_ImgState setHidden:YES];
                [m_Imglink setHidden:NO];
                [m_Img1 setHidden:NO];
                [m_Img2 setHidden:NO];
                [m_Img3 setHidden:NO];
                [m_Img4 setHidden:NO];
                if (nsTimer == nil) {
                    [self timeDisplay];
                    nsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeDisplay) userInfo:nil repeats:YES];
                }
                
        }
        else{
                [m_ImgState setHidden:NO];
                [m_Imglink setHidden:YES];
                [m_Img1 setHidden:YES];
                [m_Img2 setHidden:YES];
                [m_Img3 setHidden:YES];
                [m_Img4 setHidden:YES];
                [m_ImgState setImage:[UIImage imageNamed:@"s_live.png"]];
                if (nsTimer == nil) {
                    nsTimer = [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(liveDisplay) userInfo:nil repeats:YES];
                }
        }

        if (m_thread == nil) {
             m_thread = [[NSThread alloc] initWithTarget:self selector:@selector(tick) object:self];
            [m_thread start];
        }
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    if(nsTimer)
    {
        [nsTimer invalidate];
        nsTimer = nil;        
    }
    bIsActived = NO;
//    while (m_thread) {
//		[NSThread sleepForTimeInterval:0.001];
//	}
    if (m_thread) {
        [m_thread release];
        m_thread =  nil;
    }
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    if(m_thread)
        [m_thread release];
    
    if (nsTimer)
        [nsTimer release];
    
    [result release];
    [flagsImg release];
    [round_names release];
    
    [m_Imgbg release];
    [m_ImgState release];
    [m_Img1 release];
    [m_Img2 release];
    [m_Img3 release];
    [m_Img4 release];
    [m_Imglink release];
    [countryImgView release];
    [m_ImgRound release];
    [match_lbl release];
    [teamA_lbl release]; 
    [teamB_lbl release]; 
    [teamA release];
    [teamB release];
    
    [m_BigA_1 release];
    [m_BigA_2 release];
    [m_BigA_3 release];
    [m_BigB_1 release];
    [m_BigB_2 release];
    [m_BigB_3 release];
    
    [local_time_lbl release];
    [scoreA1_lbl release];
    [scoreB1_lbl release];
    [scoreA2_lbl release];
    [scoreB2_lbl release]; 
    [scoreA3_lbl release];
    [scoreB3_lbl release];
    [scoreA4_lbl release];
    [scoreB4_lbl release];
    [scoreA5_lbl release];
    [scoreB5_lbl release];
    
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Main Functions
- (void)setCurrentRound:(NSString *)round
{
    NSString *img_str;
    if ([round isEqualToString:@""])
        img_str = @"m-.png";
    else
        img_str = [NSString stringWithFormat:@"m%@.png", round];
    [m_ImgRound setImage:[UIImage imageNamed:img_str]];
}
- (void)setCurTotalScore:(NSInteger)nPosCount nScoreA:(NSString *)scoreA nScoreB:(NSString *)scoreB
{
    NSInteger nTotalA, nBigA_1, nBigA_2, nBigA_3, nTotalB, nBigB_1, nBigB_2, nBigB_3 = -1;
    
    if (nPosCount == 1) {
        nTotalA = [scoreA integerValue];
        nBigA_1 = 0;
        nBigA_2 = nTotalA;
        nBigA_3 = -1;
        
        nTotalB = [scoreB integerValue];
        nBigB_1 = 0;
        nBigB_2 = nTotalB;
        nBigB_3 = -1;
    }
    else if (nPosCount == 2) {
        nTotalA = [scoreA integerValue];
        nBigA_1 = nTotalA /10;
        nBigA_2 = nTotalA % 10;
        nBigA_3 = -1;
        
        nTotalB = [scoreB integerValue];
        nBigB_1 = nTotalB /10;
        nBigB_2 = nTotalB % 10;
        nBigB_3 = -1;
    }
    else if (nPosCount == 3) {
        nTotalA = [scoreA integerValue];
        nBigA_1 = nTotalA /100;
        if (nBigA_1 == 0 && nBigA_2 == 0) {
            nBigA_2 = -1;
        }
        nBigA_2 = (nTotalA % 100) /10;
        nBigA_3 = nTotalA % 10;
        
        nTotalB = [scoreB integerValue];
        nBigB_1 = nTotalB /100;
        if (nBigB_1 == 0 && nBigB_2 == 0) {
            nBigB_2 = -1;
        }
        nBigB_2 = (nTotalB % 100) /10;
        nBigB_3 = nTotalB % 10;
    }
    else {
        [m_BigA_2 setImage:[UIImage imageNamed:@"b-.png"]];
        [m_BigB_2 setImage:[UIImage imageNamed:@"b-.png"]];
        return;
    }

    
    NSString *tmpImg = @"";
    

    if (nBigA_1==0) {
        [m_BigA_1 setHidden:YES];
    }   
    else {
        [m_BigA_1 setHidden:NO];
        tmpImg = [NSString stringWithFormat:@"b%d.png", nBigA_1];
        [m_BigA_1 setImage:[UIImage imageNamed:tmpImg]];
    }
    if (nBigA_2 == -1) {
        [m_BigA_2 setHidden:YES];
    }
    else {
        [m_BigA_2 setHidden:NO];
        tmpImg = [NSString stringWithFormat:@"b%d.png", nBigA_2];
        [m_BigA_2 setImage:[UIImage imageNamed:tmpImg]];
    }
    if (nBigA_3 == -1) {
        [m_BigA_3 setHidden:YES];
    }
    else {
        [m_BigA_3 setHidden:NO];
        tmpImg = [NSString stringWithFormat:@"b%d.png", nBigA_3];
        [m_BigA_3 setImage:[UIImage imageNamed:tmpImg]]; 
    }

    
    if (nBigB_1==0) {
        [m_BigB_1 setHidden:YES];
    }   
    else {
        [m_BigB_1 setHidden:NO];
        tmpImg = [NSString stringWithFormat:@"b%d.png", nBigB_1];
        [m_BigB_1 setImage:[UIImage imageNamed:tmpImg]];
    }
    if (nBigB_2 == -1) {
        [m_BigB_2 setHidden:YES];
    }
    else {
        [m_BigB_2 setHidden:NO];
        tmpImg = [NSString stringWithFormat:@"b%d.png", nBigB_2];
        [m_BigB_2 setImage:[UIImage imageNamed:tmpImg]];
    }
    if (nBigB_3 == -1) {
        [m_BigB_3 setHidden:YES];
    }
    else {
        [m_BigB_3 setHidden:NO];
        tmpImg = [NSString stringWithFormat:@"b%d.png", nBigB_3];
        [m_BigB_3 setImage:[UIImage imageNamed:tmpImg]]; 
    }
    
}

- (void)setCurrentGameTime
{
    NSDate *today = [NSDate gmtNow];
    NSTimeInterval currentTime = [today timeIntervalSince1970];
    game_time = currentTime - [g_time integerValue];
    bLighted = NO;
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)tick
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *strurl = @"";
    NSURL    *jsonURL;
    NSString *jsonData;
    NSArray  *response;
    while (bIsActived==YES)
    {  
        strurl = [NSString stringWithFormat:@"http://%@?table=7&g_code=%@&updated=%0.0f",host, g_code, lastUpdated];
        
        //NSLog(@"Present Url:%@", strurl);
        strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        jsonURL = [NSURL URLWithString:strurl];
        jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL encoding:NSUTF8StringEncoding error:nil];
        response = [jsonData componentsSeparatedByString:@"#:#"];    
        if ([response count] == 2) {
            
            lastUpdated = [[response objectAtIndex:0] integerValue];
            result = [[[response objectAtIndex:1] JSONValue] mutableCopy];  
        }
        if (bIsActived && result && [result count]>0) {
            [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:YES];    
        }
        [NSThread sleepForTimeInterval:2.2f];
    }
    
    [pool release];
    if (m_thread) {
        [m_thread release];
        m_thread = nil;
    }
}
- (void)refresh 
{
    //Check Error
    if (result == nil || [result count] == 0) {
        return;
    }
    
    NSDictionary *m_result = [self.result objectAtIndex:0];
    
    //State Convert -->finished
    if ([[m_result objectForKey:@"s0"] isEqual:@"2"] == NO)
    {
        if(nsTimer)
        {
            [nsTimer invalidate];
            nsTimer = nil;        
        }
        bIsActived = NO;
        [self viewDidAppear:YES];
        return;
    }
   
    //Round
    NSString *strRound = [round_names objectForKey:[m_result objectForKey:@"s1"]];
    [self setCurrentRound:strRound];
    
    [self setCurTotalScore:m_countPos nScoreA:[m_result objectForKey:@"a0"] nScoreB:[m_result objectForKey:@"b0"]];
    
    //Sub Score   
    [scoreA1_lbl setText:[m_result objectForKey:@"a1"]];
    [scoreA2_lbl setText:[m_result objectForKey:@"a2"]];
    [scoreA3_lbl setText:[m_result objectForKey:@"a3"]];
    [scoreA4_lbl setText:[m_result objectForKey:@"a4"]];
    [scoreA5_lbl setText:[m_result objectForKey:@"a5"]];
        
    [scoreB1_lbl setText:[m_result objectForKey:@"b1"]];
    [scoreB2_lbl setText:[m_result objectForKey:@"b2"]];
    [scoreB3_lbl setText:[m_result objectForKey:@"b3"]];
    [scoreB4_lbl setText:[m_result objectForKey:@"b4"]];
    [scoreB5_lbl setText:[m_result objectForKey:@"b5"]];
    
}
- (void)liveDisplay
{
    float alpha_value;
    if (bLighted) {
        alpha_value = 1.0f;
    }
    else
        alpha_value = 0.5f;
    
    [m_ImgState setAlpha:alpha_value];
    bLighted = ~bLighted;
}

- (void)StateDisplay
{
    float alpha_value = (game_time % 10) * 0.1f;
    if (bLighted) {
        [m_ImgState setAlpha:(0.9f - alpha_value)];
        
    } else {
        [m_ImgState setAlpha:alpha_value];
    }
    
    
    if (alpha_value > 0.8f) {
        bLighted = ~bLighted;
    }
    game_time++;
}

- (void)timeDisplay
{
    //NSLog(@"time Tick!!");
    int nMinute10, nMinute1, nSecond10, nSecond1;
    NSString *Img1, *Img2, *Img3, *Img4;
    
    if (game_time>0) {
        nMinute10 = (int)(game_time / 60) / 10;
        if (nMinute10 > 10) {
            nMinute10 = nMinute10 % 10;
        }
        nMinute1 = (int)(game_time / 60) % 10;
        nSecond10 = (int)(game_time % 60) / 10;
        nSecond1 = (int)(game_time % 60) % 10;
    }
    else {
        nMinute10 = 0;
        nMinute1 = 0;
        nSecond10 = 0;
        nSecond1 = 0;
    }
    
    Img1 = [NSString stringWithFormat:@"s%d.png", nMinute10];
    Img2 = [NSString stringWithFormat:@"s%d.png", nMinute1];
    Img3 = [NSString stringWithFormat:@"s%d.png", nSecond10];
    Img4 = [NSString stringWithFormat:@"s%d.png", nSecond1];
    
    
    [m_Img1 setImage:[UIImage imageNamed:Img1]];
    [m_Img2 setImage:[UIImage imageNamed:Img2]];
    [m_Img3 setImage:[UIImage imageNamed:Img3]];
    [m_Img4 setImage:[UIImage imageNamed:Img4]];

    if (bLighted)
        bLighted = NO;
    else
        bLighted = YES;
    game_time ++;
}

@end
