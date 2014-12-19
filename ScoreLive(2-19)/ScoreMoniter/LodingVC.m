//
//  LodingVC.m
//  ScoreMoniter
//
//  Created by Su Jin O on 12. 2. 12..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "LodingVC.h"
#import "ScoreMoniterAppDelegate.h"
@implementation LodingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    ScoreMoniterAppDelegate *appDelegate = (ScoreMoniterAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *num = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    if (num) {
        NSString *strurl = [NSString stringWithFormat:@"http://%@?table=0&num=%@", appDelegate.host, num];
        //NSLog(@"Phone-number:%@", num);
        
        strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSURL *jsonURL = [NSURL URLWithString:strurl];
        NSString *response = [[NSString alloc] initWithContentsOfURL:jsonURL encoding:NSUTF8StringEncoding error:nil];
       //NSLog(@"register-%@", response);
        [response release];
    }
    // Do any additional setup after loading the view from its nib.
    
	[appDelegate enterMenuView];
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

@end
