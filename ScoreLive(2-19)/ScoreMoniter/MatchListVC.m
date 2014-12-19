#import "MatchListVC.h"
#import "FavoriteEditVC.h"
#import "JSON.h"
#import "CJSONDeserializer.h"

@implementation MatchListVC

@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive, m_table, m_searchBar,  favoriteVC;

#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
    if (g_Manager == nil) {
        g_Manager=(ScoreMoniterAppDelegate*)[[UIApplication sharedApplication]delegate];
    }  
   	self.title = NSLocalizedString(@"match",@"Match");
    [self.m_table setSeparatorColor:[UIColor grayColor]];
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    
    UIBarButtonItem *rightbutton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"all",@"All") style:UIBarButtonItemStyleBordered target:self action:@selector(AllCheck:)];
    self.navigationItem.rightBarButtonItem =rightbutton;
    [rightbutton release];  
	
}

- (void)AllCheck:(id)sender
{
    if(favoriteVC==nil)
    {
        favoriteVC = [[FavoriteEditVC alloc] initWithNibName:@"FavoriteEditVC" bundle:[NSBundle mainBundle]]; 
    }
    [favoriteVC.match_lbl setText:NSLocalizedString(@"All Match", @"All Match")];
    favoriteVC.gn_code = @"%";
    [[self navigationController] popToViewController:favoriteVC animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    NSString *location_str = favoriteVC.location_code;
    NSString *strurl = nil;
    strurl = [NSString stringWithFormat:@"http://%@?table=2&type=%d&location=%@", g_Manager.host, [g_Manager g_Scope], location_str];
    //NSLog(@"match-URL:%@", strurl);
    
    strurl = [strurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *jsonURL = [NSURL URLWithString:strurl];
	NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL encoding:NSUTF8StringEncoding error:nil];
    self.listContent = [[jsonData JSONValue] mutableCopy];
    [jsonData release];
    
  	[[NSUserDefaults standardUserDefaults] setObject:self.listContent forKey:@"list"];
    
    // create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
    
    if ([self.listContent count]>0) {
        [self.m_table setScrollEnabled:YES];
    }
   	[m_table reloadData];

    
}

- (void)viewDidUnload
{
	self.filteredListContent = nil;
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (void)dealloc
{
	[listContent release];
	[filteredListContent release];
	[super dealloc];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
    NSDictionary * product;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        product = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        product = [self.listContent objectAtIndex:indexPath.row];
    }
	[cell.textLabel setTextColor:[UIColor colorWithRed:172.0/255 green:172.0/255 blue:172.0/255 alpha:1.0f]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
	cell.textLabel.text = [product objectForKey:@"name"];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *product = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        product = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        product = [self.listContent objectAtIndex:indexPath.row];
    }
    [self.searchDisplayController.searchResultsTableView setHidden:YES];
    [self.searchDisplayController setActive:NO];
    if(favoriteVC==nil)
    {
        favoriteVC = [[FavoriteEditVC alloc] initWithNibName:@"FavoriteEditVC" bundle:[NSBundle mainBundle]]; 
    }
    [favoriteVC.match_lbl setText:[product objectForKey:@"name"]];
    favoriteVC.gn_code = [product objectForKey:@"code"];
    [[self navigationController] popToViewController:favoriteVC animated:YES];}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    NSString * tmpStr = nil;
	for (NSDictionary *product in listContent)
	{
        tmpStr = [product objectForKey:@"name"];
		NSComparisonResult result = [tmpStr compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
		{
			[self.filteredListContent addObject:product];
         }
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
			[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
			[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
}


@end

