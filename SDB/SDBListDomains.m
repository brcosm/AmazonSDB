
#import "SDBListDomains.h"

@implementation SDBListDomains

#pragma mark - Operation initialization

- (id)init {
    return [self initWithMaxNumberOfDomains:0 NextToken:nil];
}

- (id)initWithMaxNumberOfDomains:(int)max NextToken:(NSString *)next {
    self = [super init];
    if (self) {
        [_parameters setValue:@"ListDomains" forKey:@"Action"];
        if (max) [_parameters setValue:[NSString stringWithFormat:@"%d", max] forKey:@"MaxNumberOfDomains"];
        if (next) [_parameters setValue:[NSString stringWithFormat:@"%@", next] forKey:@"NextToken"];
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
    if ([elementName isEqualToString:@"Attribute"]) inAttribute = YES;
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    // Add the characters to the current string
    [currentElementString appendString:string];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // We are done with the DomainName tag and it should be added to the response dictionary
    if ([elementName isEqualToString:@"DomainName"]) {
        [self.responseDictionary setValue:currentElementString forKey:[NSString stringWithString:currentElementString]];
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    // Create a dictionary to store the resposne data
    self.responseDictionary = [NSMutableDictionary dictionary];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

@end
