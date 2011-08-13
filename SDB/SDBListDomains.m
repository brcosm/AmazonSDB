//
//  SDBListDomains.m
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBListDomains.h"

@implementation SDBListDomains

#pragma mark - Operation initialization

- (id)init {
    return [self initWithMaxNumberOfDomains:0 nextToken:nil];
}

- (id)initWithMaxNumberOfDomains:(int)max nextToken:(NSString *)next {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"ListDomains" forKey:@"Action"];
        if (max) [parameters_ setValue:[NSString stringWithFormat:@"%d", max] forKey:@"MaxNumberOfDomains"];
        if (next) [parameters_ setValue:[NSString stringWithFormat:@"%@", next] forKey:@"NextToken"];
    }
    return self;
}

#pragma mark - NSXML Parsing delegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    
    // We are done with the DomainName tag and it should be added to the response dictionary
    if ([elementName isEqualToString:@"DomainName"]) {
        [responseDictionary_ setValue:currentElementString_ forKey:[NSString stringWithString:currentElementString_]];
    }
    else if ([elementName isEqualToString:@"NextToken"]) {
        [responseDictionary_ setValue:currentElementString_ forKey:@"NextToken"];
        hasNextToken_ = YES;
    }
}

@end
