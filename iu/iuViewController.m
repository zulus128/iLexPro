//
//  iuViewController.m
//  iu
//
//  Created by вадим on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iuViewController.h"
#import "Common.h"
#import "ASIDownloadCache.h"

// Private stuff
@interface iuViewController ()
- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest;
- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest;
@end

@implementation iuViewController

@synthesize site;
@synthesize lastReq;
//@synthesize HTMLtext;
@synthesize dataPath;
//@synthesize bk;

@synthesize request, requestsInProgress;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)initWithAddress:(NSString*)url  del:(BOOL)del{
    
    if (self = [super init]) {
        
        removeable = del;
    }
    
	return self;
}

- (void)bck {
    
    [self.site stopLoading];
    [self.site goBack];
}

- (void)del {
    
//    [[Common instance] removeTab:self];
}

- (void)rgtButtVis {

    NSRange textRange;
    textRange =[[self.site.request.mainDocumentURL.absoluteString lowercaseString] rangeOfString:[TEST_STRING1 lowercaseString]];
        
    [fi setEnabled:(textRange.location != NSNotFound)];

}

- (void)addFav {
    
    NSRange textRange;
    textRange =[[self.site.request.mainDocumentURL.absoluteString lowercaseString] rangeOfString:[TEST_STRING1 lowercaseString]];
    
    UIAlertView* alert;
    
    if(textRange.location != NSNotFound) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Внимание" 
                                                        message:@"Добавить в загруженные?"
                                                       delegate:self 
                                              cancelButtonTitle:@"Отмена"
                                              otherButtonTitles:@"Добавить",nil];
    }
    else {

        alert = [[UIAlertView alloc] initWithTitle:@"Нельзя добавить!" 
                                           message:@"В загруженные можно добавлять только документы!"
                                          delegate:self 
                                 cancelButtonTitle:@"ОК"
                                 otherButtonTitles:/*@"Добавить",*/nil];

    }

    
    [alert show];
    [alert release];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
  
        toFav = YES;
        [Common instance].surl = [self.lastReq stringByReplacingOccurrencesOfString: TEST_STRING1 withString: TEST_STRING2];
       
        [self.site loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: [Common instance].surl]
                                                 cachePolicy: NSURLRequestReturnCacheDataElseLoad
                                             timeoutInterval: 10.0]];
//        NSLog(@"Ok");
//        Item* it = [[Item alloc] init];
//        it.link = self.lastReq;
//        it.type = TYPE_ARTICLE;
//        it.title = [site stringByEvaluatingJavaScriptFromString:@"document.title"];
////        it.full_text = [site stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//        NSLog(@"addFav: %@, %@", it.title, self.lastReq);
//        [[Common instance]saveFav:it];
//        [it release];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    bi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(bck)] autorelease];
    self.navigationItem.leftBarButtonItem = bi; 

    fi = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"28-star.png"] style: UIBarButtonItemStylePlain target:self action:@selector(addFav)] autorelease]; 
    self.navigationItem.rightBarButtonItem = fi;
    
    firsttime = YES;
    
    [super viewDidLoad];
    
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
//    [site retain];
}

- (void)fetchURL:(NSURL *)url
{
    
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
	[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
	[request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
	
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
	[request startAsynchronous];
}

- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
	NSLog(@"%@",[NSString stringWithFormat:@"Something went wrong: %@",[theRequest error]]);
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
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
		[self.site loadHTMLString:response baseURL:baseURL];
	} else {
//		[responseField setText:[theRequest responseString]];
		[self.site loadHTMLString:[theRequest responseString] baseURL:baseURL];
	}
	
	NSLog(@"fetch: %@",[[theRequest url] absoluteString]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)theRequest 
 navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        self.lastReq = [theRequest.URL absoluteString];
//		[self fetchURL:[theRequest URL]];
        NSLog(@"tapped: %@", [theRequest.URL absoluteString]);
//		return NO;
	}
    
    NSRange textRange;
    textRange =[[[theRequest.URL absoluteString] lowercaseString] rangeOfString:[TEST_STRING lowercaseString]];
    
    if(textRange.location != NSNotFound) {
        
        [bi setEnabled:NO];
    }
    else
        [bi setEnabled:self.site.canGoBack];

    
    [self rgtButtVis];
    
    if (toFav) {
        
        NSLog(@"toASI: %@", [theRequest URL]);
        [self fetchURL:[theRequest URL]];
    }
    
	return YES;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    if(![Common instance].fromFav) {
    
//        NSString* urlAdress = [Common instance].surl;
//        NSURL *url = [NSURL URLWithString:urlAdress];
//        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//        [self.site loadRequest:requestObj];
    
            [self.site loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: [Common instance].surl]
                                                 cachePolicy: NSURLRequestReturnCacheDataElseLoad
                                             timeoutInterval: 10.0]];
        }
    else {
                
//        NSString *path = [[NSBundle mainBundle] bundlePath];
//        NSURL *baseURL = [NSURL fileURLWithPath:path];
//        [self.site loadHTMLString: [Common instance].HTMLtext baseURL:baseURL];

        NSString* urlAdress = [Common instance].surl;
        NSURL *url = [NSURL URLWithString:urlAdress];
        [self fetchURL:url];

    }
    
//    [self cacheFile];
        
    [bi setEnabled:self.site.canGoBack];
    [self rgtButtVis];
    toFav = NO;
    [Common instance].fromFav = NO;

}

//- (void) cacheFile
//{
//    //Create the file/directory pointer for the storage of the cache.
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    self.dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"cache.html"];
//    
//    //Check to see if a file exists a the location
//    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
//        //Code for customising when the cache reloads would go here.
//    }
//    else
//    {
//        //If no file exists write the html cache to it
//        //Download and write to file
//        NSURL *cacheUrl = [NSURL URLWithString:[Common instance].surl];
//        NSData *cacheUrlData = [NSData dataWithContentsOfURL:cacheUrl];
//        [cacheUrlData writeToFile:dataPath atomically:YES]; 
//    }
//    //Run the load web view function.
//    [self loadWebView];
//}
//
//
//- (void) loadWebView
//{
//    //Load up the web view from the cache.
//    [self.site loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:dataPath]]];
//    
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return YES;
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    NSLog(@"finishLoad");
    
    NSString *theTitle=[site stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = theTitle;
    
    [Common instance].surl = self.site.request.mainDocumentURL.absoluteString;

    [bi setEnabled:self.site.canGoBack];

    [self rgtButtVis];

    if(toFav) {
    
//        NSLog(@"Ok to Fav");
        Item* it = [[Item alloc] init];
        it.link = [Common instance].surl;
        it.type = TYPE_ARTICLE;
        it.title = [site stringByEvaluatingJavaScriptFromString:@"document.title"];
//        it.full_text = [site stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        NSLog(@"addFav: %@, %@", it.title, [Common instance].surl);
        [[Common instance]saveFav:it];
        [it release];
    }

    toFav = NO;
    
//    self.HTMLtext = [site stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
}

- (void)dealloc {
    
    self.lastReq = nil;
    
    [bi release];
    [fi release];
    
    [super dealloc];
}

@end
