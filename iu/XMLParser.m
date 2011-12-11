//
//  XMLParser.m
//  XMLpars
//
//  Created by вадим on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"
#import "Common.h"

@implementation XMLParser

@synthesize item;

- (XMLParser *) initXMLParser: (int) type {
	
	[super init];
    
    itype = type;
    
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
  //  NSLog(@"Start Element");
   
//    if(itype == TYPE_BANNERS)
//        return;
    
	if([elementName isEqualToString:ITEM_TAG]) {

		item = [[Item alloc] init];
        item.type = itype;
        
        NSLog(@"Item alloc type = %i", itype);
	}
	
//    if ([elementName isEqualToString:IMAGE_TAG])
//        item.image = [attributeDict objectForKey:@"url"];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
		
	NSString* trimedStr;
	if(currentElementValue)
		trimedStr = [currentElementValue stringByTrimmingCharactersInSet:
						   [NSCharacterSet whitespaceAndNewlineCharacterSet]];


//    if (itype == TYPE_BANNERS) {
//        
//        if([elementName isEqualToString:LINKBANNER_TAG])
//            [Common instance].bannerLink = trimedStr;
//        if([elementName isEqualToString:SMALLBANNER_TAG])
//            [Common instance].bannerSmall = trimedStr;
//        if([elementName isEqualToString:BIGBANNER_TAG])
//            [Common instance].bannerBig = trimedStr;
//    }
//    else
    if([elementName isEqualToString:ITEM_TAG]) {
			
        switch (itype) {
            case TYPE_NEWS:
                [[Common instance] addNews:item];                
                break;
//            case TYPE_QAS:
//                [[Common instance] addQA:item];                
//                break;
//            case TYPE_PCS:
//                [[Common instance] addPodcast:item];                
//                break;
                
            default:
                break;
        }
        [item release];
    }
    else
        if([elementName isEqualToString:TITLE_TAG])
            item.title = trimedStr;
            else
                if([elementName isEqualToString:LINK_TAG]) 
                    item.link = trimedStr;
//                    else
//						if([elementName isEqualToString:RUBRIC_TAG])
//							item.rubric = trimedStr;
//                            else
//                                if([elementName isEqualToString:FULLTEXT_TAG])
//                                    item.full_text = trimedStr;
                                    else
                                        if([elementName isEqualToString:DATE_TAG])
                                            item.date = trimedStr;
                                            else
                                                if([elementName isEqualToString:DESCRIPTION_TAG])
                                                    item.description = trimedStr;
//                                                    else
//                                                        if([elementName isEqualToString:ITUNESLINK_TAG])
//                                                            item.ituneslink = trimedStr;
	
	[currentElementValue release];
	currentElementValue = nil;

}

- (void) dealloc {

	[item release];
	
	[currentElementValue release];
	[super dealloc];
}

@end
