//
//  SoccerVC.m
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoccerVC.h"
#import "CustomCell.h"
#import "FavoriteEditVC.h"
#import "TimeZoneVC.h"
#import "PresentVC.h"
#import "GameMenuVC.h"
#import "JSON.h"
#import "CJSONDeserializer.h"
#import "LabeledActivityIndicatorView.h"
#import "ScoreMoniterAppDelegate.h"
#import "ImageCrop.h"


/*
@implementation UINavigationBar (Custom)
- (void)drawRect:(CGRect)rect {
	UIImage *img = [UIImage imageNamed: @"toolbar.png"];
	[img drawInRect:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	
	self.tintColor = [UIColor colorWithRed:0.2667 green:0.18 blue:0.145 alpha:1.0];
}
@end*/


@implementation SoccerVC
@synthesize m_table, m_selectView, m_searchBar, m_toolbar,m_barbutton;
@synthesize result, sectionList, match_list, match_checklist, country, matchValue, teamValue;
@synthesize filteredListContent, savedSearchTerm, Game_state, savedScopeButtonIndex, searchWasActive, bIsUpdated, nTimeZone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    if(m_thread)
    {
        [m_thread release];
        m_thread = nil;
    }
    if (flagsImg) {
        [flagsImg release];
        flagsImg = nil;
    }
    if (flagsList) {
        [flagsList release];
        flagsList = nil;
    }
    
    [m_searchBar release];
    [m_selectView release];
    
    [m_toolbar release];
    [m_barbutton release];
    if (m_table) {
        [m_table release];
        m_table = nil;
    }
    [result release];
    [ajaxResult release];
    [match_list release];
    [match_checklist release];
    [sectionList release];
    [filteredListContent release];	
    [savedSearchTerm release];

    [presetViewControl release];
    [favoriteVC release];
    [timeZoneVC release];
    [gameMenuVC release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    g_Manager=(ScoreMoniterAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //customize Toolbar
//    UIImageView *toolBarBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar.png"]];
//	[m_toolbar insertSubview:toolBarBackView atIndex:0];
//	[toolBarBackView release];
    
    //Loading from DataBase
    g_Manager.bIsFavoriteUpdate = NO;
    bIsThread = YES;
    bIsUpdated = NO;
    Game_state = @"%";//All View
    [m_barbutton setImage:[UIImage imageNamed:@"all.png"]];
    
    //Section List Data(by Group)
    sectionList =[[[NSMutableArray alloc]init] retain];
    //Search List Data
	result  = [[[NSMutableArray alloc]init] retain];
    ajaxResult = [[[NSMutableArray alloc]init] retain];
    //Match check List
    match_list  = [[[NSMutableArray alloc]init] retain];
    match_checklist = [[[NSMutableArray alloc]init] retain];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"flags_index" ofType:@"plist"];
    
    flagsList = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    flagsImg = [UIImage imageNamed:@"flags.png"];
    
    [self.m_table setSeparatorColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1.0]];
    self.m_table.scrollEnabled = YES;
    
    //Add
  	self.filteredListContent = [NSMutableArray arrayWithCapacity:20];
    
    UIBarButtonItem *leftbutton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back",@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(Cancel:)];
    self.navigationItem.leftBarButtonItem = leftbutton;
    [leftbutton release]; 
}

- (void)Cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.m_searchBar setHidden:YES];
    
    [m_selectView setFrame:CGRectMake(0, 380, 320, 44)];
    [self.navigationController setNavigationBarHidden:NO];
    LabeledActivityIndicatorView *aiv =[[LabeledActivityIndicatorView alloc]initWithController:self andText:NSLocalizedString(@"loading", @"loading...")];
    [m_table setUserInteractionEnabled:NO];
    nTimeZone = g_Manager.nTimeZone;
    [aiv show];
    aiv.tag = 1000;
}
- (void)viewDidAppear:(BOOL)animated 
{
    
    NSDate *nowTime_gmt = [NSDate gmtNow];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger hour = [[calendar components:NSHourCalendarUnit fromDate:nowTime_gmt] hour];
    NSInteger minute = [[calendar components:NSMinuteCalendarUnit fromDate:nowTime_gmt] minute];
    NSInteger second = [[calendar components:NSSecondCalendarUnit fromDate:nowTime_gmt] second];

    minTime = [nowTime_gmt timeIntervalSince1970];
    minTime -= (hour*60*60 + minute*60 + second);
    maxTime = minTime + 86400.0;
    
    if (country == nil) {
        country = [NSString stringWithFormat:@"%"];
    }
    if (teamValue == nil) {
        teamValue = [NSString stringWithFormat:@"%"];
    }
    if (matchValue == nil) {
        matchValue = [NSString stringWithFormat:@"%"];
    }
//    if ([g_Manager bIsFavoriteUpdate] == NO) {
        if ([g_Manager g_Scope]== soccer)
        {
            country = [[g_Manager g_SoccerSave] objectAtIndex:3];
            teamValue=[[g_Manager g_SoccerSave] objectAtIndex:4];
            matchValue=[[g_Manager g_SoccerSave] objectAtIndex:5];
            Game_state = g_Manager.soccer_state;
        }
        else if ([g_Manager g_Scope] == basketball)
        {
            country = [[g_Manager g_BasketSave] objectAtIndex:3];
            teamValue=[[g_Manager g_BasketSave] objectAtIndex:4];
            matchValue=[[g_Manager g_BasketSave] objectAtIndex:5];
            Game_state = g_Manager.basketball_state;
        }
        else if ([g_Manager g_Scope] == volleyball)
        {
            country = [[g_Manager g_VolleySave] objectAtIndex:3];
            teamValue=[[g_Manager g_VolleySave] objectAtIndex:4];
            matchValue=[[g_Manager g_VolleySave] objectAtIndex:5];
            Game_state = g_Manager.volleyball_state;
        }
        else if ([g_Manager g_Scope] == baseball)
        {
            country = [[g_Manager g_BaseBSave] objectAtIndex:3];
            teamValue=[[g_Manager g_BaseBSave] objectAtIndex:4];
            matchValue=[[g_Manager g_BaseBSave] objectAtIndex:5];
            Game_state = g_Manager.baseball_state;
        }
        else if ([g_Manager g_Scope] == hockey)
        {
            country = [[g_Manager g_Hockey] objectAtIndex:3];
            teamValue=[[g_Manager g_Hockey] objectAtIndex:4];
            matchValue=[[g_Manager g_Hockey] objectAtIndex:5];
            Game_state = g_Manager.hockey_state;
        }
        else if ([g_Manager g_Scope] == tennis)
        {
            country = [[g_Manager g_TennisSave] objectAtIndex:3];
            teamValue=[[g_Manager g_TennisSave] objectAtIndex:4];
            matchValue=[[g_Manager g_TennisSave] objectAtIndex:5];
            Game_state = g_Manager.tennis_state;
        }
        else
        {
            //Error
            return;
        }
        self.navigationItem.rightBarButtonItem = nil;
        if ([Game_state isEqualToString:@"1"]) {
            [m_barbutton setImage:[UIImage imageNamed:@"schedule.png"]];
        }
        else if ([Game_state isEqualToString:@"2"]) {
            [m_barbutton setImage:[UIImage imageNamed:@"live.png"]];
        }
        else if ([Game_state isEqualToString:@"3"]) {
            [m_barbutton setImage:[UIImage imageNamed:@"finished.png"]];
        }
        else if ([Game_state isEqualToString:@"4"]) {
            [m_barbutton setImage:[UIImage imageNamed:@"favorite.png"]];
            //Navigation Bar
            UIBarButtonItem *favorite_btn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"settings",@"Settings") style:UIBarButtonItemStyleBordered target:self action:@selector(onSettingsClick:)];
            self.navigationItem.rightBarButtonItem = favorite_btn;
            [favorite_btn release];
        }
        else {
            Game_state = @"%";
            [m_barbutton setImage:[UIImage imageNamed:@"all.png"]];
        }
        
        //Match List
        NSString *strurl = [NSString stringWithFormat:@"http://%@?table=4&type=%d&time=%0.0f",g_Manager.host,[g_Manager g_Scope], minTime];
        //NSLog(@"Match Url:%@", strurl);
        
        strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSURL *jsonURL1 = [NSURL URLWithString:strurl];
        NSString *jsonData1 = [[NSString alloc] initWithContentsOfURL:jsonURL1 encoding:NSUTF8StringEncoding error:nil];
        if (match_list == nil) {
            match_list =[[[NSMutableArray alloc]init] retain];
        }
        match_list = [[jsonData1 JSONValue] mutableCopy];
        [match_checklist removeAllObjects];
        for (int i=0; i<[match_list count]; i++) {
            [match_checklist addObject:@"1"];
        }
//        g_Manager.bIsFavoriteUpdate = YES;
//    }

    if (match_list == nil || [match_list count] == 0) {
        [[self.view viewWithTag:1000] removeFromSuperview];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:NSLocalizedString(@"server error",@"Server Error!") delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"O K") otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
        [sectionList removeAllObjects];
        [result removeAllObjects];
        [m_table reloadData];
        [m_table setUserInteractionEnabled:NO];
        bIsThread = NO;
        bIsUpdated = NO;
        return;
        
    }
    //NSLog(@"Match_list:%@", match_list);
    [self startConnection];
    [[self.view viewWithTag:1000] removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    bIsThread = NO;
//    while (m_thread) {
//		[NSThread sleepForTimeInterval:0.001];
//	}
    if (m_thread) {
        [m_thread release];
        m_thread = nil;
    }
    if ([g_Manager g_Scope] == soccer)
    {
        g_Manager.soccer_state = Game_state;
    }
    else if ([g_Manager g_Scope] == basketball)
    {
        g_Manager.basketball_state= Game_state;
    }
    else if ([g_Manager g_Scope] == volleyball)
    {
        g_Manager.volleyball_state= Game_state;
    }
    else if ([g_Manager g_Scope] == baseball)
    {
        g_Manager.baseball_state= Game_state;
    }
    else if ([g_Manager g_Scope] == hockey)
    {
        g_Manager.hockey_state= Game_state;
    }
    else if ([g_Manager g_Scope] == tennis)
    {
        g_Manager.tennis_state= Game_state;
    }
    [[self.view viewWithTag:1000] removeFromSuperview];
}
- (void)viewDidUnload
{
    //[super viewDidUnload];
}

#pragma mark - main Function
- (void)startConnection {
    [self executeHTTP]; //Static Data Upload
    if (m_thread == nil) {
        m_thread = [[NSThread alloc] initWithTarget:self selector:@selector(executeAjax:) object:self];
        [m_thread start];
    }
    //[m_table setUserInteractionEnabled:YES];
}
- (void)stopConnection {
    bIsThread = NO;
    bIsUpdated = NO;
    [m_table setUserInteractionEnabled:NO];
//    while (m_thread) {
//		[NSThread sleepForTimeInterval:0.001];
//	}
    if (m_thread) {
        [m_thread release];
        m_thread = nil;
    }
}

- (void)executeHTTP {
    NSString    *strurl = @"";
    NSURL       *jsonURL;
    NSString    *jsonData = @"";
    NSArray     *records;
    //Initialize
    if (sectionList == nil) {
        sectionList =[[[NSMutableArray alloc]init] retain];
    }    
    if (result == nil) {
        result = [[[NSMutableArray alloc]init] retain];
    }
    [sectionList removeAllObjects];
    [result removeAllObjects];
    [m_table setUserInteractionEnabled:NO];
    bIsThread = YES;    //Dynamic Data Upload
    bIsUpdated = YES;
	
    //Section Header
    if ([Game_state isEqualToString:@"4"])//Favorite State
    {
        strurl = [NSString stringWithFormat:@"http://%@?table=5&type=%d&time=%0.0f&state=4&updated=0&country=%@&fgncode=%@&teamcode=%@",g_Manager.host, g_Manager.g_Scope, minTime, country, matchValue, teamValue];
    }
    else {
        strurl = [NSString stringWithFormat:@"http://%@?table=5&type=%d&time=%0.0f&state=%@&updated=0&gncode=%@",g_Manager.host, g_Manager.g_Scope, minTime, Game_state, [self make_Match_SQL]];
    }
    //NSLog(@"section url= %@", strurl);
    strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    jsonURL = [NSURL URLWithString:strurl];
    jsonData = jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL encoding:NSUTF8StringEncoding error:nil];
    if (jsonData == Nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",@"Error") message:NSLocalizedString(@"network error",@"Network connection Failed!") delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"O K") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [m_table reloadData];
        [m_table setUserInteractionEnabled:NO];
        bIsThread = NO;
        bIsUpdated = NO;
        return;
    }
    records = [jsonData componentsSeparatedByString:@"#:#"]; 
    if (records == Nil || [records count]<2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",@"Error") message:NSLocalizedString(@"network error",@"Network connection Failed!") delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"O K") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [m_table reloadData];
        [m_table setUserInteractionEnabled:NO];
        bIsThread = NO;
        bIsUpdated = NO;
        return;
    }
    lastUpdateTime = [[records objectAtIndex:0] integerValue];
    sectionList = [[(NSString *)[records objectAtIndex:1] JSONValue] mutableCopy];
    
   
    //Table Static Data (HTTP)
    if ([Game_state isEqualToString:@"4"])//Favorite State
    {
        strurl = [NSString stringWithFormat:@"http://%@?table=6&type=%d&time=%0.0f&state=4&updated=0&country=%@&fgncode=%@&teamcode=%@",g_Manager.host, g_Manager.g_Scope, minTime, country, matchValue, teamValue];
    }else {
        strurl = [NSString stringWithFormat:@"http://%@?table=6&type=%d&time=%0.0f&state=%@&updated=0&gncode=%@",g_Manager.host, g_Manager.g_Scope, minTime, Game_state, [self make_Match_SQL]];
    }
    //NSLog(@"http_url= %@", strurl);
    strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    jsonURL = [NSURL URLWithString:strurl];
    jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL encoding:NSUTF8StringEncoding error:nil];
    records = [jsonData componentsSeparatedByString:@"#:#"]; 
    lastUpdateTime = [[records objectAtIndex:0] integerValue];
    result = [[(NSString *)[records objectAtIndex:1] JSONValue] mutableCopy]; 
    
    [m_table reloadData];
    [m_table setUserInteractionEnabled:YES];
    bIsSelected = NO;
    bIsUpdated = NO;
  
}
- (void)executeAjax:(id)sender
{
    //NSLog(@"executeAjax!");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *strurl = @"";
    NSURL    *jsonURL;
    NSString *jsonData = @"";
    NSArray  *response;
    NSInteger i, j;
    
    while (bIsThread) 
    {
        if ([Game_state isEqualToString:@"4"])//Favorite State
        {
            strurl = [NSString stringWithFormat:@"http://%@?table=6&type=%d&time=%0.0f&state=4&updated=%0.0f&country=%@&fgncode=%@&teamcode=%@",g_Manager.host, g_Manager.g_Scope, minTime, lastUpdateTime, country, matchValue, teamValue];
        }else {
            strurl = [NSString stringWithFormat:@"http://%@?table=6&type=%d&time=%0.0f&state=%@&updated=%0.0f&gncode=%@",g_Manager.host, g_Manager.g_Scope, minTime, Game_state, lastUpdateTime, [self make_Match_SQL]];
        }
        //NSLog(@"ajax_url:%@", strurl);
        
        strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        jsonURL = [NSURL URLWithString:strurl];
        jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL encoding:NSUTF8StringEncoding error:nil];
        
        response = [jsonData componentsSeparatedByString:@"#:#"];    
        if ([response count] == 2) {

        lastUpdateTime = [[response objectAtIndex:0] integerValue];
        ajaxResult = [[[response objectAtIndex:1] JSONValue] mutableCopy];  
        }
        
        //NSLog(@"ajaxResult:%@", ajaxResult);
       
        //Update AjaxData from HTTP_Result
        if (ajaxResult == nil || [ajaxResult count] == 0) {
            bIsUpdated = NO;
            //NSLog(@"no Data!");
        }
        else
        {
            //NSLog(@"***** updateData ***** count:%d", [ajaxResult count]);
            for (i= 0; i<[result count]; i++) {
                for (j=0; j<[ajaxResult count]; j++) {
                    if ([[[result objectAtIndex:i] objectForKey:@"g_code"] isEqual:[[ajaxResult objectAtIndex:j] objectForKey:@"g_code"]])
                    {
                        [result replaceObjectAtIndex:i withObject:[ajaxResult objectAtIndex:j]];
                    }
                }
            }
            bIsUpdated = YES;
        }
       
        //Refresh Table 
        if (bIsThread && bIsUpdated) {
            [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:YES];    
        }
        [NSThread sleepForTimeInterval:g_Manager.delay];
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
    if (result==nil || sectionList == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",@"Error") message:NSLocalizedString(@"network error",@"Network connection Failed!") delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"O K") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        sectionList =[[[NSMutableArray alloc]init] retain];
        [sectionList removeAllObjects];
        result  = [[[NSMutableArray alloc]init] retain];
        [result removeAllObjects];
        [m_table reloadData];
        [m_table setUserInteractionEnabled:NO];
        bIsThread = NO;
        bIsUpdated = NO;
        return;
    }
    [m_table reloadData];
}

#pragma mark - table
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
	else
	{
        return [self.sectionList count];;
    }
 
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 20.0f)];
    [customView setBackgroundColor:[UIColor colorWithRed:(51.0f/255.0f) green:(51.0f/255.0f) blue:(51.0f/255.0f) alpha:0.85f]];
	//UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    //[customView addSubview:backImg];
    //[backImg release];
    
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(28.0f, 0.0f, 300.0f, 20.0f)];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.highlightedTextColor = [UIColor blackColor];
	headerLabel.font = [UIFont systemFontOfSize:13];
    
    UIImageView *countryImgView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 4.0f, 18.0f, 12.0f)];
    // i.e. array element
	[customView addSubview:headerLabel];
    [customView addSubview:countryImgView];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
      	[headerLabel setText:@"search_list"];
    }
    else
    {
        if(section >=[sectionList count])//Check Error
        {
            [headerLabel setText:@""];
            [customView addSubview:headerLabel];
            [customView addSubview:countryImgView];
            [countryImgView release];
            [headerLabel release];
            return customView;
            
        }
        [headerLabel setText:[[sectionList objectAtIndex:section] objectForKey:@"name"]]; 
        NSString * tmp = [[self.sectionList objectAtIndex:section] objectForKey:@"sid"]; 
        NSInteger countryId = [[flagsList objectForKey:tmp] integerValue];
//        if (flagsImg == nil) {
//            flagsImg = [UIImage imageNamed:@"flags.png"];
//        }
        flagsImg = [UIImage imageNamed:@"flags.png"];

        [countryImgView setImage:[flagsImg getContryImg:countryId]];
    }

    [headerLabel release];
    [countryImgView release];
    
	return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20.0f;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *oneSection = [self.sectionList objectAtIndex:section];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [[oneSection objectForKey:@"countIn"] intValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sectionNum = [indexPath section];
    NSInteger rowNum = [indexPath row];
    static NSString *customIdentifier = @"customcellidentifier";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:customIdentifier];
    if(cell==nil){
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"CustomCell"  owner:self options:nil];
        cell =[nib objectAtIndex:0];
        //[nib release];
    }
    UIImageView *selectedBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 64.0f)];
    [selectedBackView setBackgroundColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:0.5]];
    cell.selectedBackgroundView = selectedBackView;
    [selectedBackView release];
    if(sectionNum >= [sectionList count])
    {
        return cell;//Check Error
    }
    //Add
    NSInteger tmpNum = 0;
    NSInteger sumNum = 0;
    for (NSInteger i=0; i<sectionNum; i++) {
        tmpNum = [[[sectionList objectAtIndex:i] objectForKey:@"countIn"] intValue];
        sumNum +=tmpNum;
    }
    sumNum +=rowNum;
    NSDictionary *rowData = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        rowData = [self.filteredListContent objectAtIndex:rowNum];
        
    }
	else
	{
        if (sumNum >= [result count]) {
            return cell;//Check Error
        }
        rowData = [result objectAtIndex:sumNum];
    }
    cell.team1.text = [rowData objectForKey:@"teamA"];
    cell.team2.text = [rowData objectForKey:@"teamB"];
    
    //Get Game StartTime

    NSInteger   startTime = [[rowData objectForKey:@"g_time"] integerValue] + (nTimeZone*3600);
    NSDate *StartDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setTimeStyle:NSDateFormatterShortStyle];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *time_str = [dateFormat stringFromDate:StartDate];
    [dateFormat release];
    dateFormat = nil;
    [cell.start_time setText:time_str]; 
    NSString *curGMT = [NSString stringWithFormat:@"%@%d",(nTimeZone>-1) ? @"GMT+":@"GMT", nTimeZone];
    [cell.gmt setText:curGMT];
    
    if ([[rowData objectForKey:@"s0"] isEqual:@"2"]) {
        [cell.status_Img setImage:[UIImage imageNamed:@"live-state.png"]];
    } else if ([[rowData objectForKey:@"s0"] isEqual:@"3"]){
        [cell.status_Img setImage:[UIImage imageNamed:@"fin-state.png"]];
    }
    else
    {
        [cell.status_Img setImage:[UIImage imageNamed:@"sce-state.png"]];
    }
    
    NSString *score1 = [rowData objectForKey:@"a0"];
    NSString *score2 = [rowData objectForKey:@"b0"];
    
    if ([score1 isEqualToString:@""]) {
        score1 = @"0";
    }
    if ([score2 isEqualToString:@""]) {
        score2 = @"0";
    }
    [cell.score1 setText:score1];
    [cell.score2 setText:score2];
 
    return cell;
}

- (void) deselect
{	
	[self.m_table deselectRowAtIndexPath:[self.m_table indexPathForSelectedRow] animated:YES];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sectionList == nil || result == nil) {
        //Section List Data(by Group)
        sectionList =[[[NSMutableArray alloc]init] retain];
        //Search List Data
        result  = [[[NSMutableArray alloc]init] retain];
        return;
    }
    
    NSInteger sectionNum = [indexPath section];
    NSInteger rowNum = [ indexPath row];
    NSInteger tmpNum = 0;
    NSInteger sumNum = 0;
    for (NSInteger i=0; i<sectionNum; i++) {
        tmpNum = [[[sectionList objectAtIndex:i] objectForKey:@"countIn"] intValue];
        sumNum +=tmpNum;
    }
    sumNum +=rowNum;
    
    NSDictionary *RowData = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        RowData = [self.filteredListContent objectAtIndex:rowNum];
    }
	else
	{
        if (sumNum >= [result count])//Check Error
        {
            return;
        }
        RowData = [result objectAtIndex:sumNum];
    }
    //OSJ
    [m_table setUserInteractionEnabled:NO];
    bIsThread = NO;
    bIsUpdated = NO;//(table refresh Stop)
    if(presetViewControl==nil)
    {
        presetViewControl = [[PresentVC alloc] initWithNibName:@"PresentVC" bundle:[NSBundle mainBundle]]; 
    }
    NSString * tmp = [[self.sectionList objectAtIndex:indexPath.section] objectForKey:@"sid"]; 
    NSInteger countryId = [[flagsList objectForKey:tmp] integerValue];
    presetViewControl.title = self.title;
    presetViewControl.m_countryID = countryId;
    presetViewControl.nTimeZone   = nTimeZone;
    presetViewControl.host = g_Manager.host;
    presetViewControl.refreshDelay = g_Manager.delay;
    presetViewControl.g_type = g_Manager.g_Scope;
    presetViewControl.g_code = [RowData objectForKey:@"g_code"];
    presetViewControl.gn_name= [RowData objectForKey:@"gn_name"];
    presetViewControl.teamA  = [RowData objectForKey:@"teamA"];
    presetViewControl.teamB  = [RowData objectForKey:@"teamB"];
    

    [self.navigationController pushViewController:presetViewControl animated:YES];
    [self.searchDisplayController setActive:NO];
    bIsSelected = TRUE;
//    [self performSelector:@selector(deselect) withObject:NULL afterDelay:0.5];
    
    
}
- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(bIsSelected)
       return nil;
    return  indexPath;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.0f;
}
#pragma mark - toolbar

- (IBAction) onSearchClick {
    if ([self.m_searchBar isHidden]) {
        [self.m_searchBar setHidden:NO];
    }
    else{
        [self.m_searchBar setHidden:YES];        
    }
}
- (IBAction) onRefreshClick
{
    Game_state = @"%";//All View
    [m_barbutton setImage:[UIImage imageNamed:@"all.png"]];
    country = @"%";
    teamValue  = @"%";
    matchValue = @"%";    
    [self viewDidAppear:NO];
    
}
- (void)selectViewAnimation:(BOOL)show
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect frame = m_selectView.frame;
    if (show)
        frame.origin.y -= 48;
    else
        frame.origin.y += 48;
    m_selectView.frame = frame;
    [UIView commitAnimations]; 
}
- (IBAction) onScopeClick
{  
    if (m_selectView.frame.origin.y == 380)
        [self selectViewAnimation:YES];
    else
        [self selectViewAnimation:NO];
}
- (IBAction) onAllGameClick {
    LabeledActivityIndicatorView *aiv = [[LabeledActivityIndicatorView alloc]initWithController:self andText:NSLocalizedString(@"loading", @"loading...")];
    [aiv show];
    aiv.tag = 1000;
    
    Game_state = @"%";  //All Game
    [m_barbutton setImage:[UIImage imageNamed:@"all.png"]];
    [self selectViewAnimation:NO];
    self.navigationItem.rightBarButtonItem = nil;
    
    [self stopConnection];
    [self startConnection];
    
    [[self.view viewWithTag:1000] removeFromSuperview];
}
- (IBAction) onLiveGameClick {
    LabeledActivityIndicatorView *aiv = [[LabeledActivityIndicatorView alloc]initWithController:self andText:NSLocalizedString(@"loading", @"loading..")];
    [aiv show];
    aiv.tag = 1000;
    
    [m_table setUserInteractionEnabled:NO];
    Game_state = @"2";  //Live Game
    [m_barbutton setImage:[UIImage imageNamed:@"live.png"]];
    [self selectViewAnimation:NO];
    self.navigationItem.rightBarButtonItem = nil;
    
    [self stopConnection];
    [self startConnection];
    
    [[self.view viewWithTag:1000] removeFromSuperview];
}
- (IBAction) onFinishGameClick {
    LabeledActivityIndicatorView *aiv = [[LabeledActivityIndicatorView alloc]initWithController:self andText:NSLocalizedString(@"loading", @"loading..")];
    [aiv show];
    aiv.tag = 1000;
    
    [m_table setUserInteractionEnabled:NO];
    Game_state = @"3";  //Finised Game
    [m_barbutton setImage:[UIImage imageNamed:@"finished.png"]];
    [self selectViewAnimation:NO];
    self.navigationItem.rightBarButtonItem = nil;
    
    [self stopConnection];
    [self startConnection];

    [[self.view viewWithTag:1000] removeFromSuperview];
}
- (IBAction) onScheduleClick {
    LabeledActivityIndicatorView *aiv = [[LabeledActivityIndicatorView alloc]initWithController:self andText:NSLocalizedString(@"loading", @"loading..")];
    [aiv show];
    aiv.tag = 1000;
    
    [m_table setUserInteractionEnabled:NO];
    Game_state = @"1";  //Schedule Game
    [m_barbutton setImage:[UIImage imageNamed:@"schedule.png"]];
    [self selectViewAnimation:NO];
    self.navigationItem.rightBarButtonItem = nil;
    
    [self stopConnection];
    [self startConnection];
    [[self.view viewWithTag:1000] removeFromSuperview];
}
- (IBAction) onFavoriteClick {
    LabeledActivityIndicatorView *aiv = [[LabeledActivityIndicatorView alloc]initWithController:self andText:NSLocalizedString(@"loading", @"loading..")];
    [aiv show];
    aiv.tag = 1000;
    
    [m_table setUserInteractionEnabled:NO];
    Game_state = @"4";  //Schedule Game
    [m_barbutton setImage:[UIImage imageNamed:@"favorite.png"]];
    [self selectViewAnimation:NO];
    //Navigation Bar
    UIBarButtonItem *favorite_btn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"settings",@"Settings") style:UIBarButtonItemStyleBordered target:self action:@selector(onSettingsClick:)];
    self.navigationItem.rightBarButtonItem = favorite_btn;
    [favorite_btn release];

    [self stopConnection];
    [self startConnection];

    [[self.view viewWithTag:1000] removeFromSuperview];
}
- (IBAction) onTimeZoneClick
{
    if (timeZoneVC == nil) {
        timeZoneVC = [[TimeZoneVC alloc] initWithNibName:@"TimeZoneVC" bundle:[NSBundle mainBundle]]; 
    }
    timeZoneVC.soccerVC = self;
    g_Manager.bIsFavoriteUpdate = NO;
    [self.navigationController pushViewController:timeZoneVC animated:YES];
}
- (void) onSettingsClick:(id)sender;
{
    if (favoriteVC == nil) {
        favoriteVC = [[FavoriteEditVC alloc] initWithNibName:@"FavoriteEditVC" bundle:[NSBundle mainBundle]]; 
    }
    g_Manager.bIsFavoriteUpdate = NO;
    [self.navigationController pushViewController:favoriteVC animated:YES];
}
- (IBAction) onGameMenuClick
{
    if (gameMenuVC == nil) {
        gameMenuVC = [[GameMenuVC alloc] initWithNibName:@"GameMenuVC" bundle:[NSBundle mainBundle]]; 
    }

    gameMenuVC.soccerVC = self;
    [self.navigationController pushViewController:gameMenuVC animated:YES];
}
#pragma mark UISearchDisplayController Delegate Methods
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
    NSString *search_scope = @"";
    if ([scope isEqualToString:@"Match"]) {
        search_scope = @"gn_name";
    }
    else if ([scope isEqualToString:@"TeamA"]) {
        search_scope = @"teamA";
    }
    else if ([scope isEqualToString:@"TeamB"]) {
        search_scope = @"teamB";
    }
    else
    {
        return;
    }
    
	for (NSDictionary *record in result)
	{
        NSString *cell = [record objectForKey:search_scope];
        NSComparisonResult compareResult = [cell compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (compareResult == NSOrderedSame)
		{
            [self.filteredListContent addObject:record];
        }
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [m_searchBar setHidden:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
#pragma mark - Main Logic Function
- (NSString *)make_Match_SQL
{
    NSString *strSQL = @"";
    for (int i=0; i<[match_checklist count]; i++) {
        if ([[match_checklist objectAtIndex:i] isEqualToString:@"1"]) {
            strSQL = [NSString stringWithFormat:@"%@,%@", strSQL, [[match_list objectAtIndex:i] objectForKey:@"gn_code"]];
        }
    }
    if ([strSQL isEqualToString:@""] == NO) {
        strSQL = [strSQL substringFromIndex:1];
    }
    return strSQL;
}

@end
