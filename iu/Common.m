//
//  Common.m
//  iUnRewards
//
//  Created by вадим on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

#import "iuViewController.h"
#import "FavController.h"
#import "NewsController.h"
#import "ZastController.h"
#import "AboutController.h"

@implementation Common

@synthesize tabBar;
@synthesize filePath = _filePath;
@synthesize surl/*, surl1*/;
@synthesize HTMLtext;
@synthesize fromFav;
@synthesize fromCab;
@synthesize bFav;
@synthesize bURL;
@synthesize bTitle;

+ (Common*) instance  {
	
	static Common* instance;
	
	@synchronized(self) {
		
		if(!instance) {
			
			instance = [[Common alloc] init];
		}
	}
	return instance;
}

- (BOOL) tabBarController: (UITabBarController *) tabBarController shouldSelectViewController: (UIViewController *) viewController {

    if (viewController.title == @"Кабинет") {
    
//        self.surl1 = self.surl;
        self.surl = @"http://online.lexpro.ru/login.php";
        [Common instance].fromCab = YES;
    }    

    return YES;
}
    
- (id) init{	
	
	self = [super init];
	if(self !=nil) {
        
        news = [[NSMutableArray alloc] init];

        self.fromFav = NO;
        
        int b = [[NSUserDefaults standardUserDefaults] integerForKey:USER_KEY];
        switch (b) {
            case 2:
                self.surl = @"http://online.lexpro.ru";
                break;                
            default:
                self.surl = /*@"http://apple.com";*/@"http://open.lexpro.ru";
                break;
        }
      
        UIViewController* vc1;
        vc1 = b?[[iuViewController alloc] initWithAddress:@"http://..." del:NO]:[[ZastController alloc] init];
//        ZastController* vc1 = [[ZastController alloc] init];
        nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
//        [nav1 autorelease]; 
//        [nav1 retain];
        //    nav1.navigationBar.hidden = YES;
        vc1.title = @"LEXPRO";
        vc1.tabBarItem.image = [UIImage imageNamed:@"140-gradhat.png"];
        [vc1 release]; vc1 = nil;
        
        FavController* vc2 = [[FavController alloc] init];
        vc2.title = ZAGR_TITLE;
        UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
        vc2.tabBarItem.image = [UIImage imageNamed:@"28-star.png"];        
        [vc2 release]; vc2 = nil;

        NewsController* vc3 = [[NewsController alloc] init];
        vc3.title = @"Новости";
        UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
        vc3.tabBarItem.image = [UIImage imageNamed:@"34-coffee.png"];
        [vc3 release]; vc3 = nil;

//        iuViewController* vc4 = [[iuViewController alloc] initWithAddress:@"http://gmail.com" del:NO];
        AboutController* vc4 = [[AboutController alloc] init];
        vc4.title = @"Кабинет";
        UINavigationController* nav4 = [[UINavigationController alloc] initWithRootViewController:vc4];
        vc4.tabBarItem.image = [UIImage imageNamed:@"123-id-card.png"];
        [vc4 release]; vc4 = nil;

        
        self.tabBar = [[UITabBarController alloc] init];
        [self.tabBar setViewControllers:[NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nil]];
        self.tabBar.delegate = self;

//        [nav1 release]; nav1 = nil;
        [nav2 release]; nav2 = nil;
        [nav3 release]; nav3 = nil;
        [nav4 release]; nav4 = nil;
        //    [tabBar release]; tabBar = nil;
        
        NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* docpath = [sp objectAtIndex: 0];
        self.filePath = [docpath stringByAppendingPathComponent:@"favourites.plist"];
		BOOL fe = [[NSFileManager defaultManager] fileExistsAtPath:self.filePath];
		if(!fe) {
            
            NSLog(@"NO favourites.plist FILE !!! Creating...");
            NSString *appFile = [[NSBundle mainBundle] pathForResource:@"favourites" ofType:@"plist"];
			NSError *error;
			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager copyItemAtPath:appFile toPath:self.filePath error:&error];
			
		}

        favs = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];

	}
	return self;	
}

- (void)clearNews {
    
    [news removeAllObjects];
}

- (void)addNews: (Item*)item {
    
    [news addObject:item];
    NSLog(@"Item added, title: %@", item.title);
}

- (int) getNewsCount {
    
    return [news count];
}

- (Item*) getNewsAt: (int)num {
    
    return [news objectAtIndex:num];
}

- (BOOL) isOnlyWiFi {
    
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"onlyWiFi"];
}

- (void) saveFav: (Item*) item {
	
	int cnt = [[favs objectForKey:@"count"] intValue];
    NSLog(@"count = %i", cnt);
    cnt++;
    [favs setValue:[NSNumber numberWithInt:cnt] forKey:@"count"];
    NSDictionary *f = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:
                                                            
                                                            [NSNumber numberWithInt:item.type],
                                                            item.title == nil?@"":item.title,
                                                            item.link == nil?@"":item.link,    
//                                                            item.ituneslink == nil?@"":item.ituneslink,    
//                                                            item.rubric == nil?@"":item.rubric,
                                                            item.full_text == nil?@"":item.full_text,
                                                            item.date == nil?@"":item.date,
//                                                            item.image == nil?@"":item.image,
                                                            item.description == nil?@"":item.description,
                                                            nil]
                                                  forKeys:[NSArray arrayWithObjects:
                                                           @"Type",
                                                           @"Title",
                                                           @"Link",
//                                                           @"Ituneslink",
//                                                           @"Rubric",
                                                           @"Fulltext",
                                                           @"Date",
//                                                           @"Image",
                                                           @"Descr",
                                                           nil]];
	[favs setObject:f forKey:[NSString stringWithFormat:@"Favourite%02d", cnt]]; 
	[favs writeToFile:self.filePath atomically: YES];
}

- (void) sort: (NSMutableArray*) a {
    
    for (int i = 0; i < (a.count - 1); i++) {
        for (int j = i + 1; j < a.count; j++) {
            NSString* n1 = (NSString*)[a objectAtIndex:i];
            NSString* n2 = (NSString*)[a objectAtIndex:j];
            //            NSLog(@"i=%d, j=%d, n1 = %@, n2 = %@", i, j, n1, n2);
            if ([n1 caseInsensitiveCompare:n2] == NSOrderedDescending) {
                [a exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    //   NSLog(@"a=%@", a);
}

- (int) getFavNewsCount {
    
    NSMutableArray* arr1 = [[favs allKeys] mutableCopy];
    [self sort:arr1];
    for (int i = 0; i < arr1.count; i++) {
        //        NSLog(@"i=%d, key=%@, val=%@", i, [arr1 objectAtIndex:i], [favs objectForKey:[arr1 objectAtIndex:i]]);
        NSLog(@"i = %d, key = %@", i, [arr1 objectAtIndex:i]);
    }

    correction = [favs count];
    //NSLog(@"count = %i", [favs count] - 1);
    return correction - 1;
//    return correction;
}

- (Item*) getFavNewsAt: (int)num {
    
    NSMutableArray* arr1 = [[favs allKeys] mutableCopy];
    [self sort:arr1];
//    for (int i = 0; i < arr1.count; i++) {
//        NSLog(@"num = %d, i = %d, key = %@", num, i, [arr1 objectAtIndex:i]);
//    }
    
    //NSLog(@"num = %i", num);
    //    NSLog(@"%@",[favs allValues]);
//    NSArray* arr = [favs allValues];
//    id obj = [arr objectAtIndex:(num >= correction)?(num + 1):num];
    id obj = [favs objectForKey:[arr1 objectAtIndex:(num + 1)]];
//    if([obj isKindOfClass:[NSNumber class]]) {
//        
//        correction = num;
//        //  NSLog(@"correction = %i", correction);
//        obj = [arr objectAtIndex:(num >= correction)?(num + 1):num];
//    }
    
    Item* it = [[Item alloc] init];
    it.type = [[obj objectForKey:@"Type"] intValue];
    it.title = [obj objectForKey:@"Title"];
    it.link = [obj objectForKey:@"Link"];
//    it.ituneslink = [obj objectForKey:@"Ituneslink"];
//    it.rubric = [obj objectForKey:@"Rubric"];
    it.full_text = [obj objectForKey:@"Fulltext"];
    it.date = [obj objectForKey:@"Date"];
//    it.image = [obj objectForKey:@"Image"];
    it.description = [obj objectForKey:@"Descr"];
    
    return [it autorelease];
}

- (void) delFavNewsAt: (int)num {
    
//    [self getFavNewsAt:num];
    
    NSMutableArray* arr1 = [[favs allKeys] mutableCopy];
    [self sort:arr1];

//    NSLog(@"delete num = %i", num);
//    NSLog(@"correction1 = %i", correction);
//    NSLog(@"%@",[favs allKeys]);
    
//    NSArray* arr = [favs allKeys];
//    id obj = [arr objectAtIndex:(num >= correction)?(num + 1):num];
    [favs removeObjectForKey:/*obj*/[arr1 objectAtIndex:(num + 1)]];
//    int cnt = [[favs objectForKey:@"count"] intValue];
//    cnt--;
//    [favs setValue:[NSNumber numberWithInt:cnt] forKey:@"count"];
    
    [favs writeToFile:self.filePath atomically: YES];
}


- (void)dealloc {

    [nav1 release]; nav1 = nil;

    self.tabBar = nil;
    [_filePath release];
    self.surl = nil;
    
    [super dealloc];
}

@end
