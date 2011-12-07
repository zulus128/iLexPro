//
//  Common.h
//  iUnRewards
//
//  Created by вадим on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

//#define TEST_STRING @"http://www.uniquerewards.com/cgi-bin/click.cgi?mid="

@interface Common : NSObject {
    
    NSMutableDictionary* favs;
    int correction;
}

+ (Common*) instance;

- (void) saveFav: (Item*) item;
- (int) getFavNewsCount;
- (Item*) getFavNewsAt: (int)num;
- (void) delFavNewsAt: (int)num;

@property (nonatomic, retain) UITabBarController* tabBar;
@property (nonatomic, retain) NSString* filePath;
@property (nonatomic, retain) NSString* surl;

@end
