//
//  XMLParser.h
//  XMLpars
//
//  Created by вадим on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface XMLParser : NSObject <NSXMLParserDelegate> {

	NSMutableString* currentElementValue;
    int itype;
}

- (XMLParser *) initXMLParser: (int) type;

@property (nonatomic, retain) Item* item;

@end
