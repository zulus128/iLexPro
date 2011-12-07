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

@implementation Common

@synthesize tabBar;
@synthesize filePath = _filePath;
@synthesize surl;

+ (Common*) instance  {
	
	static Common* instance;
	
	@synchronized(self) {
		
		if(!instance) {
			
			instance = [[Common alloc] init];
		}
	}
	return instance;
}

- (id) init{	
	
	self = [super init];
	if(self !=nil) {
        
        self.surl = @"http://open.lexpro.ru";
        iuViewController* vc1 = [[iuViewController alloc] initWithAddress:@"http://..." del:NO];
        UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
        //    nav1.navigationBar.hidden = YES;
        vc1.title = @"LexPro";
        [vc1 release]; vc1 = nil;
        
        FavController* vc2 = [[FavController alloc] init];
        vc2.title = @"Закладки";
        UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
        //    nav2.navigationBar.hidden = YES;
//        UIImage *image = [UIImage imageNamed: @"28-star.png"];
//        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle: @"Закладки" image: image tag: 0];
//        vc2.tabBarItem = item;
        
        vc2.tabBarItem.image = [UIImage imageNamed:@"28-star.png"];
        
        [vc2 release]; vc2 = nil;

        iuViewController* vc3 = [[iuViewController alloc] initWithAddress:@"http://gmail.com" del:NO];
        vc3.title = @"Новости";
        UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
        //    nav2.navigationBar.hidden = YES;
        [vc3 release]; vc3 = nil;

        iuViewController* vc4 = [[iuViewController alloc] initWithAddress:@"http://gmail.com" del:NO];
        vc4.title = @"Настройки";
        UINavigationController* nav4 = [[UINavigationController alloc] initWithRootViewController:vc4];
        //    nav2.navigationBar.hidden = YES;
        [vc4 release]; vc4 = nil;

        
        self.tabBar = [[UITabBarController alloc] init];
        [self.tabBar setViewControllers:[NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nil]];

        [nav1 release]; nav1 = nil;
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

- (void) saveFav: (Item*) item {
	
	int cnt = [[favs objectForKey:@"count"] intValue];
    NSLog(@"count = %i", cnt);
    cnt++;
    [favs setValue:[NSNumber numberWithInt:cnt] forKey:@"count"];
    NSDictionary *f = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:
                                                            
//                                                            [NSNumber numberWithInt:item.type],
//                                                            
                                                            item.title == nil?@"":item.title,
                                                            item.link == nil?@"":item.link,    
//                                                            item.ituneslink == nil?@"":item.ituneslink,    
//                                                            item.rubric == nil?@"":item.rubric,
//                                                            item.full_text == nil?@"":item.full_text,
//                                                            item.date == nil?@"":item.date,
//                                                            item.image == nil?@"":item.image,
//                                                            item.description == nil?@"":item.description,
                                                            nil]
                                                  forKeys:[NSArray arrayWithObjects:
//                                                           @"Type",
                                                           @"Title",
                                                           @"Link",
//                                                           @"Ituneslink",
//                                                           @"Rubric",
//                                                           @"Fulltext",
//                                                           @"Date",
//                                                           @"Image",
//                                                           @"Descr",
                                                           nil]];
	[favs setObject:f forKey:[NSString stringWithFormat:@"Favourite%d", cnt]]; 
	[favs writeToFile:self.filePath atomically: YES];
}

- (int) getFavNewsCount {
    
    correction = [favs count];
    //NSLog(@"count = %i", [favs count] - 1);
    return correction - 1;
}

- (Item*) getFavNewsAt: (int)num {
    
    //NSLog(@"num = %i", num);
    //    NSLog(@"%@",[favs allValues]);
    NSArray* arr = [favs allValues];
    id obj = [arr objectAtIndex:(num >= correction)?(num + 1):num];
    if([obj isKindOfClass:[NSNumber class]]) {
        
        correction = num;
        //  NSLog(@"correction = %i", correction);
        obj = [arr objectAtIndex:(num >= correction)?(num + 1):num];
    }
    
    Item* it = [[Item alloc] init];
//    it.type = [[obj objectForKey:@"Type"] intValue];
    it.title = [obj objectForKey:@"Title"];
    it.link = [obj objectForKey:@"Link"];
//    it.ituneslink = [obj objectForKey:@"Ituneslink"];
//    it.rubric = [obj objectForKey:@"Rubric"];
//    it.full_text = [obj objectForKey:@"Fulltext"];
//    it.date = [obj objectForKey:@"Date"];
//    it.image = [obj objectForKey:@"Image"];
//    it.description = [obj objectForKey:@"Descr"];
    
    return [it autorelease];
}

- (void) delFavNewsAt: (int)num {
    
    [self getFavNewsAt:num];
    
//    NSLog(@"delete num = %i", num);
//    NSLog(@"correction1 = %i", correction);
//    NSLog(@"%@",[favs allKeys]);
    
    NSArray* arr = [favs allKeys];
    id obj = [arr objectAtIndex:(num >= correction)?(num + 1):num];
    [favs removeObjectForKey:obj];
    int cnt = [[favs objectForKey:@"count"] intValue];
    cnt--;
    [favs setValue:[NSNumber numberWithInt:cnt] forKey:@"count"];
    
    [favs writeToFile:self.filePath atomically: YES];
}


- (void)dealloc {

    self.tabBar = nil;
    [_filePath release];
    self.surl = nil;
    
    [super dealloc];
}

@end
