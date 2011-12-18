//
//  ZastController.m
//  iLexPro
//
//  Created by вадим on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ZastController.h"
#import "Common.h"
#import "iuViewController.h"

@implementation ZastController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        vc1 = [[iuViewController alloc] initWithAddress:@"http://..." del:NO];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)open: (id)sender {
  
    [Common instance].surl = @"http://open.lexpro.ru";
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:USER_KEY];

    [self.navigationController pushViewController:vc1 animated:YES];

}

- (IBAction)online: (id)sender {

    [Common instance].surl = @"http://online.lexpro.ru";
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:USER_KEY];
    [self.navigationController pushViewController:vc1 animated:YES];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
	return YES;
}

- (void)dealloc {
    
    [vc1 release];
    
    [super dealloc];
}

@end
