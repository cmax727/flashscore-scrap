#import <UIKit/UIKit.h>
#import "ScoreMoniterAppDelegate.h"

@class FavoriteEditVC;
@interface TeamListVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    // The master content.
	NSMutableArray			*listContent;			
    // The content filtered as a result of a search.
	NSMutableArray          *filteredListContent;		
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
    IBOutlet UITableView    *m_table;
    IBOutlet UISearchBar    *m_searchBar;
    FavoriteEditVC          *favoriteVC; //Undo ViewController
    ScoreMoniterAppDelegate *g_Manager;
}
@property (nonatomic, retain) FavoriteEditVC  *favoriteVC;
@property (nonatomic, retain) UISearchBar   *m_searchBar;
@property (nonatomic, retain) IBOutlet UITableView *m_table;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (void)AllCheck:(id)sender;
@end
