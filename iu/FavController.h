//
//  FavController.h
//  iLexPro
//
//  Created by вадим on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIWebPageRequest.h"

@interface FavController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UIWebView* aWebView;
    UITableView* tableView;
        UIBarButtonItem* bi;
}

//@property (nonatomic, retain) IBOutlet UIWebView* fsite;
@property (retain, nonatomic) ASIWebPageRequest *request;
@property (retain, nonatomic) NSMutableArray *requestsInProgress;

- (void)lftButtVis;
- (void)bck;

@end
