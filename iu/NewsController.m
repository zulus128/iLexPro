//
//  NewsController.m
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsController.h"
#import "Common.h"
#import "Reachability.h"
#import "XMLParser.h"
#import "NewsCell.h"
#import "Item.h"
#import "DetailController.h"
#import <QuartzCore/CALayer.h>

@implementation NewsController

@synthesize samplecell = _samplecell;
@synthesize tableView = _tableView;
//@synthesize topcell = _topcell;
@synthesize time = _time;

@synthesize  indi = _indi;
@synthesize lView = _lView;

//@synthesize bannerView = _bannerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    [_samplecell release];
    [_tableView release];
//    [_topcell release];
    [_time release];
    
    [_indi release];
    [_lView release];
    
//    [_bannerView release];
    
    [super dealloc];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        
        if ([currentObject isKindOfClass:[NewsCell class]]) {
            
            self.samplecell = (NewsCell*) currentObject;
            break;
        }
    }

//     topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TopNewsCell" owner:nil options:nil];
//     for (id currentObject in topLevelObjects) {
//    
//         if ([currentObject isKindOfClass:[TopNewsCell class]]) {
//     
//             self.topcell = (TopNewsCell*) currentObject;
//             break;
//         }
//     }
//
//    [self.view addSubview:self.topcell];
//    CGRect r = self.topcell.frame;
//    r.origin.y = 31;
//    self.topcell.frame = r;
//    self.topcell.nc = self;
    
    self.lView.layer.cornerRadius = 10.0f;

    hand = NO;
    [self refresh1];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
  
//    NSLog(@"viewWillAppear");

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

//    UIImage *image = [UIImage imageNamed:@"top-logo-sample.png"];
//    
//    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
//        //iOS 5 new UINavigationBar custom background
//        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
//    } 
//    
//        UIImage *image1 = [UIImage imageNamed: @"top-logo-sample.png"];
//    [self.navigationController.navigationBar setBackgroundImage:image1];
        
    
    UIBarButtonItem* bi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refr)] autorelease];
    self.navigationItem.rightBarButtonItem = bi; 
    
    [self validTable];
}

- (void)viewWillDisappear:(BOOL)animated {

//    [self.navigationController.navigationBar setBackgroundImage:NULL];

    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return YES;
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"bannerExists"])
//        return;
//    
//    UITouch *touch=[[event allTouches]anyObject];
//    CGPoint location=[touch locationInView:touch.view];
//
//    //NSLog(@"loc y = %f", location.y);
//    if(location.y < 320)
//        return;
//    
//    NSLog(@"go banner!");
//    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[Common instance].bannerLink]];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"count = %d", [[Common instance] getNewsCount]);
    return [[Common instance] getNewsCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"heightForRowAtIndexPath");

   // if ((indexPath.row == 0) || (indexPath.row == 2))
    //    return self.delimsamplecell.frame.size.height;
    return self.samplecell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // static NSString *CellIdentifier2 = @"DelimNewsCell";
   // static NSString *CellIdentifier1 = @"TopNewsCell";
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell* cell;
    
   /* if ((indexPath.row == 0) || (indexPath.row == 2)) {
        
        cell = (DelimNewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DelimNewsCell" owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                
                if ([currentObject isKindOfClass:[DelimNewsCell class]]) {
                    
                    cell = (DelimNewsCell*) currentObject;
                    break;
                }
            }
            // Configure the cell...
            if(indexPath.row == 0)
                ((DelimNewsCell*)cell).title.text = @"Тема дня";
            else
                ((DelimNewsCell*)cell).title.text = @"Главное за сегодня";

        }
    }
    else
    if (indexPath.row == 1) {
        
        cell = (TopNewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
           // NSLog(@"TopNewsCell is nil");
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TopNewsCell" owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                
                if ([currentObject isKindOfClass:[TopNewsCell class]]) {
                    
                    cell = (TopNewsCell*) currentObject;
                    break;
                }
            }
            // Configure the cell...
            Item* item = [[Common instance] getNewsAt:0];
            ((TopNewsCell*)cell).title.text = item.title;
            ((TopNewsCell*)cell).rubric.text = item.rubric;
            ((TopNewsCell*)cell).image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: item.image]]];
        }
    }else */
        {
            cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
               // NSLog(@"NewsCell is nil");
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:nil options:nil];
                for (id currentObject in topLevelObjects) {
            
                    if ([currentObject isKindOfClass:[NewsCell class]]) {
                
                        cell = (NewsCell*) currentObject;
                        break;
                    }
                }
            }
            // Configure the cell...
//            Item* item = [[Common instance] getNewsAt:(indexPath.row - ROW_CORRECTION)];
            Item* item = [[Common instance] getNewsAt:indexPath.row];
            ((NewsCell*)cell).title.text = item.title;
            ((NewsCell*)cell).rubric.text = item.description;
            ((NewsCell*)cell).time.text = [item.date substringWithRange:NSMakeRange(17, 5)];
            
            NSLog(@"Full String: %@!", item.date);
//            NSString* n = [item.date substringWithRange:NSMakeRange(5, 20)];
            NSString* n = [item.date substringWithRange:NSMakeRange(0, 25)];
            NSLog(@"String: %@", n);
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"EEE, dd MMM yyyy hh:mm:ss"];
            NSDate *myDate = [df dateFromString: n];
            NSLog(@"Date: %@", [df stringFromDate:myDate]);
//            NSLog(@"Date: %@", df);
            
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
//            ((NewsCell*)cell).title.numberOfLines = 3;
//            ((NewsCell*)cell).title.frame = CGRectMake(63,0,200,800);
//            [((NewsCell*)cell).title sizeToFit];
        }

    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    Item* item = [[Common instance] getNewsAt:indexPath.row];

    DetailController* detailViewController = [[DetailController alloc] initWithNibName:@"DetailController" bundle:nil];     
    self.hidesBottomBarWhenPushed = YES;
    detailViewController.link = item.link;
    [self.navigationController pushViewController:detailViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
//    detailViewController.image.hidden = YES;
    [detailViewController release];
     
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refr {
    
    [self refresh:YES];
}

- (void)refresh: (BOOL)hnd {

    hand = hnd;
    [self.lView setHidden:NO];
    [self.indi setHidden:NO];
    [self.indi startAnimating];
    [self performSelector:@selector(refresh1) withObject:nil afterDelay:0.0];
  //  [self refresh1:self];
}

- (void)refresh1 {
    
    NSLog(@"refresh hand = %d", hand);
    
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	    ppp = !ppp;
    
    BOOL b = [[Reachability reachabilityWithHostName:MENU_URL_FOR_REACH] currentReachabilityStatus];    
    if (([[Common instance] isOnlyWiFi] && (b != ReachableViaWiFi))
        || (![[Common instance] isOnlyWiFi] && (b == NotReachable))) {
    
		UIAlertView* dialog = [[UIAlertView alloc] init];
		[dialog setTitle:@"Убедитесь в наличии Интернета!"];
		[dialog setMessage:@"Невозможно загрузить новости."];
		[dialog addButtonWithTitle:@"OK"];
		[dialog show];
		[dialog release];
        
        [self addPreloadedNews];
        
//        Item* item = [[Common instance] getNewsAt:0];
//        self.topcell.title.text = item.title;
//        self.topcell.rubric.text = item.rubric;
//        self.topcell.image.image = [Common loadImage];
//        [Common instance].img = self.topcell.image.image;
        
        [self.tableView reloadData];
		
	}else {
        
        [[Common instance] clearNews];
//        if(![self addNews:TOPMENU_URL]) {
//            
//            [self addPreloadedNews];
//            
////            Item* item = [[Common instance] getNewsAt:0];
////            self.topcell.title.text = item.title;
////            self.topcell.rubric.text = item.rubric;
////            self.topcell.image.image = [Common loadImage];
////            [Common instance].img = self.topcell.image.image;
//            
//            [self.tableView reloadData];
//            hand = NO;
//
//        }
//        else    
            if(![self addNews:MENU_URL]) {
        
                [self addPreloadedNews];
                
//                Item* item = [[Common instance] getNewsAt:0];
//                self.topcell.title.text = item.title;
//                self.topcell.rubric.text = item.rubric;
//                self.topcell.image.image = [Common loadImage];
//                [Common instance].img = self.topcell.image.image;
                
                [self.tableView reloadData];
                hand = NO;

            }
            else {
        
                [self.tableView reloadData];
                //[sender reloadData];
                //[_tableView reloadData];
//                [[Common instance] saveNewsPreload];

                if([[Common instance] getNewsCount]) {
            
//                    Item* item = [[Common instance] getNewsAt:0];
//                    self.topcell.title.text = item.title;
//                    self.topcell.rubric.text = item.rubric;
//                    self.topcell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: item.image]]];
//                    [Common instance].img = self.topcell.image.image;
//            
//                    [Common saveImage:self.topcell.image.image];
                }
            }
    
        
        if (hand) {
            
            NSDate *now = [NSDate date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"dd.MM в hh:mm";
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            self.time.text = [NSString stringWithFormat:@"Обновлено: %@", [dateFormatter stringFromDate:now]];
            [dateFormatter release];
            
        }
        else
            self.time.text = @"";
    
	}
    
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indi stopAnimating];
    [self.lView setHidden:YES];

//    [[Common instance] refreshBanner];
    [self validTable];
}

- (void) validTable {
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"bannerExists"]) {
//    //        if (ppp) {
//        
//        self.bannerView.hidden = NO;
//        self.bannerView.image = [[Common instance] getBanner];
//        CGRect f = self.bannerView.frame;
//        f.origin.y = 323;
//        self.bannerView.frame = f;
//        f = CGRectMake(0, 140, 320, 183);
//        self.tableView.frame = f;
//    }
//    else {
//        
//        self.bannerView.hidden = YES;
//        CGRect f = CGRectMake(0, 140, 320, 227);
//        self.tableView.frame = f;
//        
//    }

}

- (void)addPreloadedNews {
//    
    [[Common instance] clearNews];
//    [[Common instance] clearQAs];
//    [[Common instance] clearPodcasts];
//    
//    [[Common instance] loadPreloaded];
}


- (BOOL)addNews: (NSString*) url {
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;//[[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //        [error release];
    if (responseData == nil) {
        // Check for problems
        if (error != nil) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:@"Ошибка Интернет-подключения"];
            [dialog setMessage:[error localizedDescription]];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
            [dialog release];
            return NO;
        }
    }

    BOOL success = YES;
    
    for (int i = 0; i < 5; i++) {
        
//    NSString *myStr = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
//    myStr = [myStr stringByReplacingOccurrencesOfString:@"encoding=\"windows-1251\"" withString:@""];
//    NSData* aData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:responseData/*aData*/];
    XMLParser* parser = [[XMLParser alloc] initXMLParser:TYPE_NEWS];
    [xmlParser setDelegate:parser];    
        
        success = [xmlParser parse];	
        
        if(success) {
            
            NSLog(@"News - No Errors");
//            [self.tableView reloadData];
            break;
        }
        else {
            
            //NSLog(@"Error! Possibly xml version is not new");
            NSLog(@"News - Parser error: %@", [[xmlParser parserError] localizedDescription]);
            success = NO;
            //return NO;
        }
    }

    return success;
}


@end
