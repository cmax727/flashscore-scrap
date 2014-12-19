//
//  TimeZoneVC.m
//  ScoreMoniter
//
//  Created by yincheng on 12/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeZoneVC.h"
#import "ImageCrop.h"
#import "SoccerVC.h"

@implementation TimeZoneVC
@synthesize curTime_lbl, curGMT_lbl, pickerView, soccerVC, Delay_lbl, Host_lbl, slider, server, update, timezone;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [server release];
    [update release];
    [timezone release];
    [curTime_lbl release];
    [curGMT_lbl  release];
    [pickerView  release];
    [Delay_lbl release];
    [Host_lbl release];
    [slider release];
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
    if (g_Manager == nil) {
        g_Manager=(ScoreMoniterAppDelegate*)[[UIApplication sharedApplication]delegate];
    }  
    // Do any additional setup after loading the view from its nib.
    pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
    self.title = NSLocalizedString(@"settings",@"Settings");
    
    [server setText: NSLocalizedString(@"server",@"Server Address :")];
    [update setText: NSLocalizedString(@"update",@"Update Period :")];
    [timezone setText: NSLocalizedString(@"timezone",@"TimeZone :")];
    
    UIBarButtonItem *leftbutton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back",@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(Cancel:)];
    self.navigationItem.leftBarButtonItem = leftbutton;
    [leftbutton release]; 
    
    UIBarButtonItem *rightbutton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done",@"Done") style:UIBarButtonItemStyleBordered target:self action:@selector(Apply:)];
    self.navigationItem.rightBarButtonItem =rightbutton;
    [rightbutton release];  
    
  	[slider addTarget:self action:@selector(UpdateDelay:) forControlEvents:UIControlEventValueChanged];
}
- (void)Cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)Apply:(id)sender
{
    g_Manager.delay = nDelay;
    g_Manager.host = [Host_lbl text];
    g_Manager.nTimeZone = nGMT;
    if(soccerVC==nil)
    {
        soccerVC = [[SoccerVC alloc] initWithNibName:@"SoccerVC" bundle:[NSBundle mainBundle]]; 
    }
    [[self navigationController] popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    nGMT = soccerVC.nTimeZone;
    nDelay = g_Manager.delay;
    [Host_lbl setText:g_Manager.host];
    [pickerView selectRow:(nGMT+11) inComponent:0 animated:YES];
    NSString *curGMT = [NSString stringWithFormat:@"%@%d",(nGMT>-1) ? @"GMT+":@"GMT", nGMT];
    [curGMT_lbl setText:curGMT];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark pickView
// Number of wheels
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }

// Number of rows per wheel
- (NSInteger)pickerView: (UIPickerView *)pView numberOfRowsInComponent: (NSInteger) component  { return 23; }

// Return the title of each cell by row and component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    int i = -11+row;
    NSDate *tmp_date = [NSDate gmtNow];
    NSDate *date = [tmp_date dateByAddingTimeInterval:(3600*i)];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd       HH:mm"];
    NSString *date_str = [dateFormat stringFromDate:date];
    NSString *str = [NSString stringWithFormat:@"%@   %@%d", date_str, (i>-1) ? @"GMT+":@"GMT", i];
    [dateFormat release];
    
	return str;
}


// Respond to user selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nGMT = -11+row;
    NSDate *tmp_date = [NSDate gmtNow];
    NSDate *date = [tmp_date dateByAddingTimeInterval:(3600*nGMT)];
    NSString *curGMT = [NSString stringWithFormat:@"%@%d",(nGMT>-1) ? @"GMT+":@"GMT", nGMT];
    [curGMT_lbl setText:curGMT];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd       HH:mm"];
    NSString *date_str = [dateFormat stringFromDate:date];
    [curTime_lbl setText:date_str];
    [dateFormat release];
}
- (void)UpdateDelay:(id)sender
{
    nDelay = 1+[slider value]*9.0f;
    [Delay_lbl setText:[NSString stringWithFormat:@"%d s", nDelay]];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [Host_lbl resignFirstResponder];
    return YES;
}
@end
