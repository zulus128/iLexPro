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
        
        iuViewController* vc1 = [[iuViewController alloc] initWithAddress:@"http://open.lexpro.ru" del:NO];
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

	}
	return self;	
}

- (void)dealloc {

    self.tabBar = nil;
    
    [super dealloc];
}

@end
