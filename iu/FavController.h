//
//  FavController.h
//  iLexPro
//
//  Created by вадим on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIWebPageRequest.h"

@interface FavController : UITableViewController

@property (nonatomic, retain) IBOutlet UIWebView* fsite;
@property (retain, nonatomic) ASIWebPageRequest *request;
@property (retain, nonatomic) NSMutableArray *requestsInProgress;

@end
