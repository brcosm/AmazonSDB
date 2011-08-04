
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

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    
    // Add all attributes that are in the results to the dictionary
    if (inAttribute_) [responseDictionary_ setValue:currentElementString_ forKey:elementName];
}

@end