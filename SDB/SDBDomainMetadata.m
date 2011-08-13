//
//  SDBDomainMetadata.m
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBDomainMetadata.h"

@implementation SDBDomainMetadata

- (id)initWithDomainName:(NSString *)domainName {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"DomainMetadata" forKey:@"Action"];
        [parameters_ setValue:[NSString stringWithString:domainName] forKey:@"DomainName"];
    }
    return self;
}

#pragma mark - NSXML Parsing delegate

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict {
    // Track the current element and empty the string to store found characters
    currentElementName_ = [NSString stringWithString:elementName];
    currentElementString_ = [NSMutableString stringWithString:@""];
    
    // Set the flag if we are in an attribute (to avoid name collision with item's name tag)
    if ([elementName isEqualToString:@"DomainMetadataResult"]) inAttribute_ = YES;
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    // Use the DomainMetadataResult tag to identify attributes
    inAttribute_ = ![elementName isEqualToString:@"DomainMetadataResult"];
    
    // Add all attributes that are in the results to the dictionary
    if (inAttribute_) [responseDictionary_ setValue:currentElementString_ forKey:elementName];
}


@end