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

#define MENU_URL_FOR_REACH @"www.lexpro.ru"
#define TOPMENU_URL @"http://lexpro.ru/rss"
#define MENU_URL @"http://lexpro.ru/rss"

#define ITEM_TAG @"item"
#define TITLE_TAG @"title"
//#define FULLTEXT_TAG @"fulltext"
#define DATE_TAG @"pubDate"
#define LINK_TAG @"link"
#define DESCRIPTION_TAG @"description"

#define USER_KEY @"USER_KEY"

#define TEST_STRING @"export?DocID="
#define TEST_STRING1 @"lexpro.ru/document/"
#define TEST_STRING2 @"lexpro.ru/stream/documents/print?DocID="

#define TEST_STRING3 @"http://open.lexpro.ru"
#define TEST_STRING4 @"http://online.lexpro.ru"
#define TEST_STRING5 @"login.php"

#define ALERT_TAG 1234
#define ABOUT_TAG 1235

#define ZAGR_TITLE @"Загруженные"

enum item_types {
    
    TYPE_NEWS,
    TYPE_ARTICLE
};

@interface Common : NSObject <UITabBarControllerDelegate> {
    
    NSMutableDictionary* favs;
    NSMutableArray* news;
    int correction;
    UINavigationController* nav1;
}

+ (Common*) instance;

- (BOOL) isOnlyWiFi;

- (void) saveFav: (Item*) item;
- (int) getFavNewsCount;
- (Item*) getFavNewsAt: (int)num;
- (void) delFavNewsAt: (int)num;
- (void)addNews: (Item*)item;

- (void)clearNews;
- (void)addNews: (Item*)item;
- (int) getNewsCount;
- (Item*) getNewsAt: (int)num;

@property (nonatomic, retain) UITabBarController* tabBar;
@property (nonatomic, retain) NSString* filePath;
@property (nonatomic, retain) NSString* surl;
//@property (nonatomic, retain) NSString* surl1;
@property (nonatomic, retain) NSString* HTMLtext;
@property (assign, readwrite) BOOL fromFav;
@property (assign, readwrite) BOOL fromCab;

@property (assign, readwrite) BOOL bFav;
@property (nonatomic, retain) NSURL* bURL;
@property (nonatomic, retain) NSString* bTitle;

@end
