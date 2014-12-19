#import <UIKit/UIKit.h>
#import "ScoreMoniterAppDelegate.h"

@class SoccerVC;
@interface GameMenuVC : UIViewController
{
    // The master content.
	NSMutableArray			*match_list;	
    NSMutableArray          *check_list;
    IBOutlet UITableView    *m_table;
    IBOutlet UIToolbar      *m_toolbar;
    ScoreMoniterAppDelegate *g_Manager;

    SoccerVC                *soccerVC; //Undo ViewController
    UIImage                 *flagsImg;
    NSDictionary            *flagsList;
}
@property (nonatomic, retain) IBOutlet UITableView  *m_table;
@property (nonatomic, retain) IBOutlet UIToolbar    *m_toolbar;
@property (nonatomic, retain) SoccerVC              *soccerVC;
@property (nonatomic, retain) NSMutableArray        *match_list, *check_list;
@property (nonatomic, retain) UIImage                 *flagsImg;
@property (nonatomic, retain) NSDictionary            *flagsList;

- (void)SaveMenu:(id)sender;
- (IBAction)AllCheck:(id)sender;
- (IBAction)AllUnCheck:(id)sender;
- (BOOL)bIsActiveCheck;
@end
