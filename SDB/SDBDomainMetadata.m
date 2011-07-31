
#import "SDBDomainMetadata.h"

@implementation SDBDomainMetadata

- (id)initWithDomainName:(NSString *)domainName {
    self = [super init];
    if (self) {
        [_parameters setValue:@"DomainMetadata" forKey:@"Action"];
        [_parameters setValue:[NSString stringWithString:domainName] forKey:@"DomainName"];
    }
    return self;
}

#pragma mark - NSXML Parsing delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict {
    
    // Track the current element and empty the string to store found characters
    currentElementName = [NSString stringWithString:elementName];
    currentElementString = [NSMutableString stringWithString:@""];
    
    // Set the flag if we are in an attribute (to avoid name collision with item's name tag)
    if ([elementName isEqualToString:@"DomainMetadataResult"]) inAttribute = YES;
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    // Add the characters to the current string
    [currentElementString appendString:string];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    // Update the flag to indicate we are no longer in an attribute (name tags are now for the item)
    if ([elementName isEqualToString:@"DomainMetadataResult"]) inAttribute = NO;
    
    // Add all attributes that are in the results to the dictionary
    if (inAttribute) [self.responseDictionary setValue:currentElementString forKey:elementName];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    // Create a dictionary to store the resposne data
    self.responseDictionary = [NSMutableDictionary dictionary];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

@end