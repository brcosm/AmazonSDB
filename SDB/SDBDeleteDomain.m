//
//  SDBDeleteDomain.m
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBDeleteDomain.h"

@implementation SDBDeleteDomain

#pragma mark - Operation initialization

- (id)init {
    return [self initWithDomainName:0];
}

- (id)initWithDomainName:(NSString *)domainName {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"DeleteDomain" forKey:@"Action"];
        if (domainName) [parameters_ setValue:[NSString stringWithString:domainName] forKey:@"DomainName"];
    }
    return self;
}

@end
