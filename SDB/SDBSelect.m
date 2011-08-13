//
//  SDBSelect.m
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBSelect.h"

@implementation SDBSelect

- (id)init {
    return [self initWithExpression:nil nextToken:nil];
}

- (id)initWithExpression:(NSString *)expression nextToken:(NSString *)next {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"Select" forKey:@"Action"];
        [parameters_ setValue:expression forKey:@"SelectExpression"];
        if (CONSISTENT_READ) [parameters_ setValue:@"true" forKey:@"ConsistentRead"];
        if (next) [parameters_ setValue:next forKey:@"NextToken"];
    }
    return self;
}

#pragma mark - NSXML Parsing delegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    
    // We found a name tag but it belongs to the Item, not the Attribute
    if ([elementName isEqualToString:@"Name"] && !inAttribute_) {
        // Update the current item name
        currentItemName_ = [NSString stringWithString:currentElementString_];
        
        // Create a new dictionary to store this item's data
        currentItemDictionary_ = [NSMutableDictionary dictionary];
    }
    
    // We found a name tag that belongs to the attribute
    else if ([elementName isEqualToString:@"Name"]) {
        // Store the name to be used as the key when we get the value
        currentKey_ = [NSString stringWithString:currentElementString_];
    }
    
    // We found an attribute value that needs to be added to the dictionary for the current key
    else if ([elementName isEqualToString:@"Value"]) {
        [currentItemDictionary_ setValue:[NSString stringWithString:currentElementString_] forKey:currentKey_];
    }
    
    // We are done with the item and its attribute dict should be added to the response dictionary
    else if ([elementName isEqualToString:@"Item"]) {
        [responseDictionary_ setValue:[NSDictionary dictionaryWithDictionary:currentItemDictionary_] forKey:currentItemName_];
    }
    
    // There is more data to retrieve
    else if ([elementName isEqualToString:@"NextToken"]) {
        [responseDictionary_ setValue:[NSString stringWithString:currentElementString_] forKey:@"NextToken"];
        hasNextToken_ = YES;
    }
}

@end
