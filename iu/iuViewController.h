//
//  iuViewController.h
//  iu
//
//  Created by вадим on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iuViewController : UIViewController <UIWebViewDelegate> {
    
    BOOL firsttime;
    BOOL removeable;

    UIBarButtonItem* bi;
    UIBarButtonItem* fi;
    
    BOOL toFav;
//    BOOL fromCab;
}

- (id)initWithAddress:(NSString*)url del:(BOOL)del;
- (void)bck;
- (void)del;
- (void)addFav;
//- (void) loadWebView;
//- (void) cacheFile;

@property (nonatomic, retain) IBOutlet UIWebView* site;
@property (nonatomic, retain) NSString* lastReq;
//@property (nonatomic, retain) NSString* HTMLtext;
@property (nonatomic, retain) NSString* dataPath;

//- (void)fetchURL:(NSURL *)url;
- (void)rgtButtVis;

//@property (nonatomic, retain) IBOutlet UIButton* bk;

@end
