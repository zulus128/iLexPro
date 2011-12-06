//
//  iuAppDelegate.h
//  iu
//
//  Created by вадим on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iuViewController;

@interface iuAppDelegate : NSObject <UIApplicationDelegate> {

//    UITabBarController* tabBar;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iuViewController *viewController;

@end
