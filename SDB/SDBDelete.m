//
//  SDBDelete.m
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBDelete.h"

@interface SDBDelete() {
}
- (void)addAttributes:(NSDictionary *)attributes;
@end

@implementation SDBDelete

- (id)init {
    return [self initWithItemName:nil attributes:nil domainName:nil];
}

- (id)initWithItemName:(NSString *)item attributes:(NSDictionary *)attributes domainName:(NSString *)domain {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"DeleteAttributes" forKey:@"Action"];
        [parameters_ setValue:item forKey:@"ItemName"];
        [parameters_ setValue:domain forKey:@"DomainName"];
        [self addAttributes:attributes];
    }
    return self;
}

- (void)addAttributes:(NSDictionary *)attributes {
    
    [attributes.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [parameters_ setValue:key forKey:[NSString stringWithFormat:@"Attribute.%d.Name",idx]];
    }];
}

@end
