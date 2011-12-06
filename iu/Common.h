//
//  Common.h
//  iUnRewards
//
//  Created by вадим on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iuViewController.h"

#define TEST_STRING @"http://www.uniquerewards.com/cgi-bin/click.cgi?mid="

@interface Common : NSObject

+ (Common*) instance;

- (void)addTab: (NSString*) str;
- (void)removeTab: (iuViewController*) cont;

@property (nonatomic, retain) UITabBarController* tabBar;

@end
