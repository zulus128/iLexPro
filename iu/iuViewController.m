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
        it.title = [site stringByEvaluatingJavaScriptFromString:@"document.title"];
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

    NSString* urlAdress = [Common instance].surl;
    NSURL *url = [NSURL URLWithString:urlAdress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.site loadRequest:requestObj];
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
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
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
}

- (void)dealloc {
    
    self.lastReq = nil;
    
    [super dealloc];
}

@end
