//
//  NewsController.h
//  iBuh
//
//  Created by вадим on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROW_CORRECTION 2

@class TopNewsCell;

@interface NewsController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
 
    BOOL hand;
    
    BOOL ppp;
//    UIView* _hudView;
}

- (void)refresh: (BOOL)hand;
- (void)refresh1;

- (void) refr;
- (BOOL) addNews: (NSString*) url;
- (void) addPreloadedNews;
- (void) validTable;

@property (nonatomic, retain) UITableViewCell* samplecell;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UILabel* time;
//@property (nonatomic, retain) TopNewsCell* topcell;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* indi;
@property (nonatomic, retain) IBOutlet UIView* lView;

//@property (nonatomic, retain) IBOutlet UIImageView* bannerView;

@end
