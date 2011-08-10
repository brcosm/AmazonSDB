
#import "SDBPut.h"

@interface SDBPut() {
    
}

- (void)addAttributes:(NSDictionary *)attributes;
@end

@implementation SDBPut

- (id)init {
    return [self initWithItemName:nil attributes:nil domainName:nil];
}

- (id)initWithItemName:(NSString *)item attributes:(NSDictionary *)attributes domainName:(NSString *)domain {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"PutAttributes" forKey:@"Action"];
        [parameters_ setValue:item forKey:@"ItemName"];
        [parameters_ setValue:domain forKey:@"DomainName"];
        [self addAttributes:attributes];
    }
    return self;
}

- (void)addAttributes:(NSDictionary *)attributes {
    __block int i = 0;
    [attributes.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *value = [attributes valueForKey:key];
        [parameters_ setValue:key forKey:[NSString stringWithFormat:@"Attribute.%d.Name",i]];
        [parameters_ setValue:value forKey:[NSString stringWithFormat:@"Attribute.%d.Value",i]];
        [parameters_ setValue:@"true" forKey:[NSString stringWithFormat:@"Attribute.%d.Replace",i]];
        i++;
    }];
}


@end
