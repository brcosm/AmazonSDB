//
//  SDBBatchPut.h
//  SDB
//
//  Created by Brandon Smith on 8/14/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBOperation.h"

@interface SDBBatchPut : SDBOperation

- (id)initWithItems:(NSDictionary *)items domainName:(NSString *)domain;

@end
