//
//  SoccerVC.h
//  ScoreMoniter
//
//  Created by yincheng on 11/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabeledActivityIndicatorView.h"
#import "ScoreMoniterAppDelegate.h"
@class PresentVC;
@class FavoriteEditVC;
@class TimeZoneVC;
@class GameMenuVC;

@interface SoccerVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    PresentVC       *presetViewControl;
    FavoriteEditVC  *favoriteVC;
    TimeZoneVC      *timeZoneVC;
    GameMenuVC      *gameMenuVC;
    
    NSThread                *m_thread;
    BOOL                    bIsThread;
    ScoreMoniterAppDelegate *g_Manager;
    IBOutlet UISearchBar    *m_searchBar;
    IBOutlet UITableView    *m_table;
    IBOutlet UIView         *m_selectView;
    IBOutlet UIToolbar      *m_toolbar;
    IBOutlet UIBarButtonItem *m_barbutton;   
    
    NSMutableArray  *result, *ajaxResult;
    NSMutableArray  *match_list;
    NSMutableArray  *match_checklist;
    NSString        *Game_state;
    NSMutableArray  *sectionList;
    NSMutableArray	*filteredListContent;	
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    UIImage         *flagsImg;
    NSDictionary    *flagsList;
    NSString        *country, *teamValue, *matchValue;
    BOOL            bIsUpdated;
    NSInteger       nTimeZone;
    NSTimeInterval  lastUpdateTime; //Database Record UpdateTime 
    NSTimeInterval  minTime;
    NSTimeInterval  maxTime;
    
    BOOL bIsSelected;
    
}
@property (nonatomic) BOOL bIsUpdated;
@property (nonatomic) NSInteger nTimeZone;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *m_barbutton;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic, retain) NSMutableArray *result, *sectionList, *filteredListContent, *match_list, *match_checklist;
@property (nonatomic, retain) IBOutlet UISearchBar * m_searchBar;
@property (nonatomic, retain) IBOutlet UITableView *m_table;
@property (nonatomic, retain) IBOutlet UIView *m_selectView;
@property (nonatomic, retain) IBOutlet UIToolbar *m_toolbar;
@property (nonatomic, retain) NSString *Game_state, *country, *teamValue, *matchValue;

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
- (IBAction) onSearchClick;
- (IBAction) onRefreshClick;
- (IBAction) onTimeZoneClick;
- (IBAction) onGameMenuClick;
- (IBAction) onScopeClick;

//Selete Scope Type(All, Live, Schedual, Finished)
- (void) onSettingsClick:(id)sender;
- (IBAction) onAllGameClick;
- (IBAction) onLiveGameClick;
- (IBAction) onFinishGameClick;
- (IBAction) onScheduleClick;
- (IBAction) onFavoriteClick;
- (IBAction) onTimeZoneClick;

- (void)Cancel:(id)sender;

- (void)selectViewAnimation:(BOOL)show;

- (void)startConnection;    //Start Runtime Ajax
- (void)stopConnection;     //Stop  Runtime Ajax
- (void)executeHTTP;        //Static Data   (Http)
- (void)executeAjax:(id)sender;//Dynamic Data  (Ajax)
- (void)refresh;            //Refresh Table    (runtime)
- (NSString *)make_Match_SQL;
@end
