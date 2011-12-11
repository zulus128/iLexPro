//
//  Item.m
//  iMenu
//
//  Created by вадим on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Item.h"


@implementation Item

@synthesize type, title, link, date, description;

- (void) dealloc {
	
    //	NSLog(@"Item dealloc");
 	self.title = nil;
	self.link = nil;
//	self.ituneslink = nil;
//	self.rubric = nil;
//	self.full_text = nil;
	self.date = nil;
//    self.image = nil;
    self.description = nil;
	
	[super dealloc];
}

@end
