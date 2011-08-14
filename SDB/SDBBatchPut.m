//
//  SDBBatchPut.m
//  SDB
//
//  Created by Brandon Smith on 8/14/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBBatchPut.h"

@interface SDBBatchPut() {
}
- (void)addItems:(NSDictionary *)items;
@end

@implementation SDBBatchPut

- (id)init {
    return [self initWithItems:nil domainName:nil];
}

- (id)initWithItems:(NSDictionary *)items domainName:(NSString *)domain {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"BatchPutAttributes" forKey:@"Action"];
        [parameters_ setValue:domain forKey:@"DomainName"];
        [self addItems:items];
    }
    return self;
}

- (void)addItems:(NSDictionary *)items {
    
    __block NSDictionary *attributes;
    
    [items.allKeys enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop) {
        
        [parameters_ setValue:item forKey:[NSString stringWithFormat:@"Item.%d.ItemName",idx]];
        
        attributes = [items valueForKey:item];
        [attributes.allKeys enumerateObjectsUsingBlock:^(NSString *attribute, NSUInteger idy, BOOL *stop) {
            
            NSString *value = [attributes valueForKey:attribute];
            [parameters_ setValue:attribute forKey:[NSString stringWithFormat:@"Item.%d.Attribute.%d.Name", idx, idy]];
            [parameters_ setValue:value forKey:[NSString stringWithFormat:@"Item.%d.Attribute.%d.Value", idx, idy]];
            
        }];
        
    }];
}

@end
