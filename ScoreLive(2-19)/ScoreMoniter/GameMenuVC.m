#import "GameMenuVC.h"
#import "SoccerVC.h"
#import "JSON.h"
#import "CJSONDeserializer.h"
#import "ImageCrop.h"

@implementation GameMenuVC

@synthesize match_list,check_list, m_table, flagsList, flagsImg, m_toolbar;
@synthesize soccerVC;

#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"menu",@"Menu");
    
    //self.navigationItem.hidesBackButton = YES;
   // match_list =[[[NSMutableArray alloc]init] retain];
    //check_list =[[[NSMutableArray alloc]init] retain];
    
    [m_table setSeparatorColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:0.6]];
    
//    UIBarButtonItem *leftbutton =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelMenu:)];
//    self.navigationItem.leftBarButtonItem = leftbutton;
//    [leftbutton release]; 
    
    UIBarButtonItem *rightbutton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done",@"Done") style:UIBarButtonItemStyleBordered target:self action:@selector(SaveMenu:)];
    self.navigationItem.rightBarButtonItem =rightbutton;
    [rightbutton release];  

    g_Manager=(ScoreMoniterAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"flags_index" ofType:@"plist"];
    
    flagsList = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    flagsImg = [UIImage imageNamed:@"flags.png"];
    
    //[self loadMyData];
}
-(void)viewDidAppear:(BOOL)animated
{
	//[self viewDidLoad];
    match_list = soccerVC.match_list;
    [soccerVC.match_list retain];
    check_list = soccerVC.match_checklist;
    [soccerVC.match_checklist retain];
    [m_table reloadData];
	//[super viewWillAppear:TRUE];
}
- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc
{
    [m_table release];
    [m_toolbar release];
//    [match_list release];
//    match_list = nil;
//    [check_list release];
//    check_list = nil;
    if (flagsImg) {
        [flagsImg release];
        flagsImg = nil;
    }
    if (flagsList) {
        [flagsList release];
        flagsList = nil;
    }
	[super dealloc];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [match_list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel     *lbladd, *lblCount;
	UIImageView *flagIcon, *checkIcon;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
		[view setBackgroundColor:[UIColor clearColor]];
		cell.backgroundView = view;
	    
		
		lbladd = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 180, 40)];
		lbladd.textColor=[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1.0];
		lbladd.font=[UIFont systemFontOfSize:14];
		lbladd.backgroundColor = [UIColor clearColor];
        lbladd.numberOfLines = 2;
		lbladd.tag = 3000;
		[cell.contentView addSubview:lbladd];
        
        lblCount = [[UILabel alloc]initWithFrame:CGRectMake(260, 0, 30, 40)];
		lblCount.textColor=[UIColor colorWithRed:(245/255.0f) green:172/255.0f blue:18/255.0f alpha:1.0f];        
        lblCount.shadowColor = [UIColor colorWithRed:172.0/255 green:120.0/255 blue:52.0/255 alpha:1.0];
		lblCount.font=[UIFont systemFontOfSize:13];
		lblCount.backgroundColor = [UIColor clearColor];
        lblCount.textAlignment = UITextAlignmentCenter;
		lblCount.tag = 3001;
		[cell.contentView addSubview:lblCount];
		
		
		flagIcon=[[UIImageView alloc]initWithFrame:CGRectMake(5, 14, 24, 15)];
		flagIcon.tag = 3002;
		[cell.contentView addSubview:flagIcon];
        
        checkIcon =[[UIImageView alloc]initWithFrame:CGRectMake(290, 12, 19, 18)];
		checkIcon.tag = 3003;
		[cell.contentView addSubview:checkIcon];
    }
    else {
		lbladd =(UILabel*)[cell.contentView viewWithTag:3000];
        lblCount =(UILabel*)[cell.contentView viewWithTag:3001];
		flagIcon =(UIImageView *)[cell.contentView viewWithTag:3002];
   		checkIcon =(UIImageView *)[cell.contentView viewWithTag:3003];
	}

    UIView * customBackground =  [[UIView alloc] init];
    [customBackground setBackgroundColor:[UIColor blackColor]];
    [cell setSelectedBackgroundView:customBackground];
    [customBackground release];
	
    if (indexPath.row >= [match_list count]) {
        return cell; //Connection Error
    }
    NSDictionary *product = [match_list objectAtIndex:indexPath.row];
   
    NSString * tmp = [product objectForKey:@"sid"]; 
    NSInteger countryId = [[flagsList objectForKey:tmp] integerValue];
//    if (flagsImg == nil) {
        flagsImg = [UIImage imageNamed:@"flags.png"];
//    }
    
    [flagIcon setImage:[flagsImg getContryImg:countryId]];
    [lbladd setText:[product objectForKey:@"name"]];
    NSString *tmpStr = [NSString stringWithFormat:@"(%@)", [product objectForKey:@"countIn"]];
    [lblCount setText:tmpStr];
    
    [checkIcon setImage:[UIImage imageNamed:@"checked.png"]];
    if ([[check_list objectAtIndex:indexPath.row] isEqual:@"1"]) {
        [checkIcon setHidden:NO];
    }
    else
    {
        [checkIcon setHidden:YES];
    }
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Check Error
    if (indexPath.row >= [match_list count]) {
        return;
    }
    if ([[check_list objectAtIndex:indexPath.row] isEqual:@"0"]) {
        [check_list replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    else {
        [check_list replaceObjectAtIndex:indexPath.row withObject:@"0"]; 
    }
    [m_table reloadData];
//    NSDictionary *product = [match_list objectAtIndex:indexPath.row];
//    if(soccerVC == nil)
//    {
//        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:[NSBundle mainBundle]]; 
//    }
//    soccerVC.matchValue = [product objectForKey:@"name"];
//    soccerVC.teamValue  = @"All Team";
//    soccerVC.bIsUpdated = NO;
//    soccerVC.Game_state = @"%";//All View
//    [soccerVC.m_barbutton setImage:[UIImage imageNamed:@"all-game.png"]];
//    [[self navigationController] popToViewController:soccerVC animated:YES];
}

#pragma mark Custom Functions


//- (void)CancelMenu:(id)sender
//{
//    g_Manager.bIsFavoriteUpdate = YES;
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)SaveMenu:(id)sender
{
    if(soccerVC == nil)
    {
        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:[NSBundle mainBundle]]; 
    }
    if (check_list == nil || [self bIsActiveCheck] == FALSE) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",@"Error") message:NSLocalizedString(@"select error", @"You've never checked!") delegate:self cancelButtonTitle:NSLocalizedString(@"ok",@"O K") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    //soccerVC.match_checklist = [check_list mutableCopy];
    soccerVC.matchValue = @"%";
    soccerVC.teamValue  = @"%";
    soccerVC.bIsUpdated = NO;
    soccerVC.Game_state = @"%";//All View
    [soccerVC.m_barbutton setImage:[UIImage imageNamed:@"all.png"]];
    [[self navigationController] popToViewController:soccerVC animated:YES];
}
- (BOOL)bIsActiveCheck 
{
    for (int i=0; i<[check_list count]; i++) {
        if ([[check_list objectAtIndex:i] isEqualToString:@"1"]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (IBAction)AllCheck:(id)sender
{
    for (int i=0; i<[check_list count]; i++) {
        [check_list replaceObjectAtIndex:i withObject:@"1"];
    }
    [m_table reloadData];
}

- (IBAction)AllUnCheck:(id)sender
{
    for (int i=0; i<[check_list count]; i++) {
        [check_list replaceObjectAtIndex:i withObject:@"0"];
    }
    [m_table reloadData];
}
@end

