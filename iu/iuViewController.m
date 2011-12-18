//
//  iuViewController.m
//  iu
//
//  Created by вадим on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iuViewController.h"
#import "Common.h"

@implementation iuViewController

@synthesize site;
@synthesize lastReq;
//@synthesize HTMLtext;
@synthesize dataPath;

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
    
    [self.site goBack];
}

- (void)del {
    
//    [[Common instance] removeTab:self];
}

- (void)addFav {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Внимание" 
                                                    message:@"Добавить в закладки?"
                                                   delegate:self 
                                          cancelButtonTitle:@"Отмена"
                                          otherButtonTitles:@"Добавить",nil];
    [alert show];
    [alert release];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSLog(@"Ok");
        Item* it = [[Item alloc] init];
        it.link = self.lastReq;
        it.type = TYPE_ARTICLE;
        it.title = [site stringByEvaluatingJavaScriptFromString:@"document.title"];
        it.full_text = [site stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];

        NSLog(@"addFav: %@, %@", it.title, self.lastReq);
        [[Common instance]saveFav:it];
        [it release];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    UIBarButtonItem* bi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(bck)] autorelease];
    self.navigationItem.leftBarButtonItem = bi; 

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"28-star.png"] style: UIBarButtonItemStylePlain target:self action:@selector(addFav)] autorelease];    
    
    firsttime = YES;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

//    if(![Common instance].fromFav) {
//    
//        NSString* urlAdress = [Common instance].surl;
//        NSURL *url = [NSURL URLWithString:urlAdress];
//        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//        [self.site loadRequest:requestObj];

    [self.site loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: [Common instance].surl]
                                           cachePolicy: NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval: 60.0]];
    
    //    }
//    else {
//        
//        [self.site loadHTMLString: [Common instance].HTMLtext baseURL:nil];
//
//    }
    
//    [self cacheFile];
    
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    /*
    //You might need to set up a interceptLinks-Bool since you don't want to intercept the initial loading of the content
    if (self.interceptLinks) {
        NSURL *url = request.URL;
        //This launches your custom ViewController, replace it with your initialization-code
        [BrowserViewController openBrowserWithUrl:url];     
        return NO;
    }
    //No need to intercept the initial request to fill the WebView
    else {
        self.interceptLinks = TRUE;
        return YES;
    }
    */

//    if(firsttime) {
//        
//        firsttime = NO;
//        return YES;
//    }

//    NSLog(@"Loading %@", [request.URL absoluteString]);
    
    self.lastReq = [request.URL absoluteString];
    
//    if ([[request.URL absoluteString] hasPrefix:TEST_STRING]) {
//        
//        [[Common instance] addTab:[request.URL absoluteString]];
//        return NO;
//    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    NSString *theTitle=[site stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = theTitle;
    
    [Common instance].surl = self.site.request.mainDocumentURL.absoluteString;

//    self.HTMLtext = [site stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
}

- (void)dealloc {
    
    self.lastReq = nil;
    
    [super dealloc];
}

@end
