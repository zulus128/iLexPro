//
//  Item.h
//  iMenu
//
//  Created by вадим on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject {

}
//@property (assign, readwrite) int type;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* link;
//@property (nonatomic, retain) NSString* ituneslink;
//@property (nonatomic, retain) NSString* rubric;
//@property (nonatomic, retain) NSString* full_text;
//@property (nonatomic, retain) NSString* date;
//@property (nonatomic, retain) NSString* image;
//@property (nonatomic, retain) NSString* description;
//do not forget to add to save favourites in Common.h


@end
