
#import "SDBSelect.h"

@implementation SDBSelect
@synthesize responseDictionary;

- (id)init {
    return [self initWithExpression:nil NextToken:nil];
}

- (id)initWithExpression:(NSString *)expression NextToken:(NSString *)next {
    self = [super init];
    if (self) {
        [_parameters setValue:@"Select" forKey:@"Action"];
        [_parameters setValue:expression forKey:@"SelectExpression"];
        if (next) [_parameters setValue:next forKey:@"NextToken"];
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
    
    // We found a name tag but it belongs to the Item, not the Attribute
    if ([elementName isEqualToString:@"Name"] && !inAttribute) {
        // Update the current item name
        currentItemName = [NSString stringWithString:currentElementString];
        
        // Create a new dictionary to store this item's data
        currentItemDictionary = [NSMutableDictionary dictionary];
    }
    
    // We found a name tag that belongs to the attribute
    else if ([elementName isEqualToString:@"Name"]) {
        // Store the name to be used as the key when we get the value
        currentKey = [NSString stringWithString:currentElementString];
    }
    
    // We found an attribute value that needs to be added to the dictionary for the current key
    else if ([elementName isEqualToString:@"Value"]) {
        [currentItemDictionary setValue:[NSString stringWithString:currentElementString] forKey:currentKey];
    }
    
    // We are done with the item and its attribute dict should be added to the response dictionary
    else if ([elementName isEqualToString:@"Item"]) {
        [self.responseDictionary setValue:currentItemDictionary forKey:currentItemName];
    }
    
    // Update the flag to indicate we are no longer in an attribute (name tags are now for the item)
    if ([elementName isEqualToString:@"Attribute"]) inAttribute = NO;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    // Create a dictionary to store the resposne data
    self.responseDictionary = [NSMutableDictionary dictionary];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

@end
