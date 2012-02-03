//
//  FavController.m
//  iLexPro
//
//  Created by вадим on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FavController.h"
#import "Common.h"
#import "ASIDownloadCache.h"

// Private stuff
@interface FavController ()
- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest;
- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest;
@end

@implementation FavController

//@synthesize fsite;
@synthesize request;
@synthesize requestsInProgress;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)lftButtVis {
    
    [bi setEnabled:(aWebView.hidden == NO)];
}

- (void)bck {
    
    aWebView.hidden = YES;
    tableView.hidden = NO;
    [self lftButtVis];
    self.navigationItem.title = ZAGR_TITLE;
    [aWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];    

}

- (void)fetchURL:(NSURL *)url
{
 	
    [aWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];    

    [self setRequestsInProgress:[NSMutableArray array]];
    
	[request setDelegate:nil];
	[request cancel];
	
    //    ASIHTTPRequest *req                     = [ASIHTTPRequest requestWithURL:url];
    //    request.shouldAttemptPersistentConnection   = NO;
    
    [self setRequest:[ASIWebPageRequest requestWithURL:url]];
    
	[request setDidFailSelector:@selector(webPageFetchFailed:)];
	[request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
	[request setDelegate:self];
	[request setDownloadProgressDelegate:self];
	[request setUrlReplacementMode:(YES /*1111*/ ? ASIReplaceExternalResourcesWithData : ASIReplaceExternalResourcesWithLocalURLs)];
	
	// It is strongly recommended that you set both a downloadCache and a downloadDestinationPath for all ASIWebPageRequests
	[request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [request setSecondsToCache:60*60*24*365];
    
	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
	[request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
	
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
	[request startAsynchronous];
    
//    if([Common instance].bFav) {
     
        self.navigationItem.title = [Common instance].bTitle;
//    }
}

- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
	NSLog(@"%@",[NSString stringWithFormat:@"Something went wrong: %@",[theRequest error]]);
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
    
//    toFav = NO;
    
	NSURL *baseURL;
	if (YES /*1111*/) {
		baseURL = [theRequest url];
        
        // If we're using ASIReplaceExternalResourcesWithLocalURLs, we must set the baseURL to point to our locally cached file
	} else {
		baseURL = [NSURL fileURLWithPath:[request downloadDestinationPath]];
	}
    
	if ([theRequest downloadDestinationPath]) {
		NSString *response = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
        //		[responseField setText:response];
		[aWebView loadHTMLString:response baseURL:baseURL];
	} else {
        //		[responseField setText:[theRequest responseString]];
		[aWebView loadHTMLString:[theRequest responseString] baseURL:baseURL];
	}
	
	NSLog(@"FetchSucceded: %@",[[theRequest url] absoluteString]);
    
    if([Common instance].bFav) {
        
        //        NSLog(@"Ok to Fav");
        Item* it = [[Item alloc] init];
        it.link = [[Common instance].bURL absoluteString];
        it.type = TYPE_ARTICLE;
        it.title = [Common instance].bTitle;//[aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
        //        it.full_text = [site stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        NSLog(@"addFav: %@, %@", it.title, it.link);
        [[Common instance]saveFav:it];
        [it release];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Внимание!" 
                                                        message:@"Офф-лайн версия документа добавлена в 'Загруженные'."
                                                       delegate:self 
                                              cancelButtonTitle:@"ОК"
                                              otherButtonTitles:/*@"Добавить",*/nil];
        alert.tag = ALERT_TAG;
        
        [alert show];
        [alert release];
    }
    [Common instance].bFav = NO;
    [tableView reloadData];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
//    [self.navigationController.view addSubview:self.fsite];
//    [self.navigationController.view bringSubviewToFront:self.fsite];

    bi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(bck)] autorelease];
    self.navigationItem.leftBarButtonItem = bi; 
    
    //	init and create the UIWebView
    aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 655)];
//    aWebView.autoresizesSubviews = YES;
//    aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
//    [aWebView setDelegate:self];
//    NSString *urlAddress = @"http://www.google.com";
//    NSURL *url = [NSURL URLWithString:urlAddress];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    [aWebView loadRequest:requestObj];
//    [self.view addSubview:aWebView];

//    [self.navigationController.view addSubview:aWebView];
//    [self.navigationController.view bringSubviewToFront:aWebView];
//    [aWebView setBackgroundColor:[UIColor clearColor]];
//    [aWebView setBackgroundColor:[UIColor purpleColor]];
//    [aWebView setOpaque:NO];
    
    [self.view addSubview:aWebView];
    [self.view bringSubviewToFront:aWebView];

    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1024, 655) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    
//    NSLog(@"webview finishLoad");
//    
//    if([Common instance].bFav) {
//        
//        //        NSLog(@"Ok to Fav");
//        Item* it = [[Item alloc] init];
//        it.link = [Common instance].surl;
//        it.type = TYPE_ARTICLE;
//        it.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
//        //        it.full_text = [site stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//        NSLog(@"addFav: %@, %@", it.title, [Common instance].surl);
//        [[Common instance]saveFav:it];
//        [it release];
//        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Внимание!" 
//                                                        message:@"Офф-лайн версия документа добавлена в 'Загруженные'."
//                                                       delegate:self 
//                                              cancelButtonTitle:@"ОК"
//                                              otherButtonTitles:/*@"Добавить",*/nil];
//        alert.tag = ALERT_TAG;
//        
//        [alert show];
//        [alert release];
//    }
//    [Common instance].bFav = NO;
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    [aWebView release];
    aWebView = nil;
    
    [tableView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableView reloadData];
    
    if([Common instance].bFav) {
        
        aWebView.hidden = NO;
        tableView.hidden = YES;
        
        NSLog(@"toASI: %@", [Common instance].bURL);
        [self fetchURL:[Common instance].bURL];
    }
    else {

        tableView.hidden = NO;
        aWebView.hidden = YES;

    }
    
//    [Common instance].bFav = NO;
    [self lftButtVis];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [aWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return YES;
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Удалить";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"rows count = %d", [[Common instance] getFavNewsCount]);
    return [[Common instance] getFavNewsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Item* item = [[Common instance] getFavNewsAt:indexPath.row];
    cell.textLabel.text = item.title;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView1 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[Common instance] delFavNewsAt:indexPath.row];
        [tableView1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
//    [Common instance].fromFav = YES;
    
    Item* item = [[Common instance] getFavNewsAt:indexPath.row];
//    [Common instance].surl = item.link;
//    [Common instance].HTMLtext = item.full_text;
//    [Common instance].tabBar.selectedIndex = 0;
    
    aWebView.hidden = NO;
    tableView.hidden = YES;
    
    [Common instance].bURL = [NSURL URLWithString:item.link];
    [Common instance].bTitle = item.title;
    NSLog(@"fromASI: %@", [Common instance].bURL);
    [self fetchURL:[Common instance].bURL];
    [self lftButtVis];
}

@end
