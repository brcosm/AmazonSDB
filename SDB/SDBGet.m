//
//  SDBGet.m
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBGet.h"

@interface SDBGet() {
}
- (void)addAttributes:(NSArray *)attributes;
@end

@implementation SDBGet

- (id)init {
    return [self initWithItemName:nil attributes:nil domainName:nil];
}

- (id)initWithItemName:(NSString *)item attributes:(NSArray *)attributes domainName:(NSString *)domain {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"GetAttributes" forKey:@"Action"];
        [parameters_ setValue:item forKey:@"ItemName"];
        [parameters_ setValue:domain forKey:@"DomainName"];
        if (CONSISTENT_READ) [parameters_ setValue:@"true" forKey:@"ConsistentRead"];
        if (attributes) [self addAttributes:attributes];
    }
    return self;
}

- (void)addAttributes:(NSArray *)attributes {
    [attributes enumerateObjectsUsingBlock:^(NSString *attribute, NSUInteger idx, BOOL *stop) {
        [parameters_ setValue:attribute forKey:[NSString stringWithFormat:@"AttributeName.%d",idx]];
    }];
}

#pragma mark - NSXML Parsing delegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    
    if (!currentItemDictionary_) currentItemDictionary_ = [NSMutableDictionary dictionary];
    
    // We found a name tag that belongs to the attribute
    if ([elementName isEqualToString:@"Name"]) {
        // Store the name to be used as the key when we get the value
        currentKey_ = [NSString stringWithString:currentElementString_];
    }
    
    // We found an attribute value that needs to be added to the dictionary for the current key
    else if ([elementName isEqualToString:@"Value"]) {
        [currentItemDictionary_ setValue:[NSString stringWithString:currentElementString_] forKey:currentKey_];
    }
    
    else if ([elementName isEqualToString:@"GetAttributesResult"]) {
        [responseDictionary_ setValue:[NSDictionary dictionaryWithDictionary:currentItemDictionary_] forKey:[parameters_ valueForKey:@"ItemName"]];
    }
}

@end