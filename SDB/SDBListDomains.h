//
//  SDBListDomains.h
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//


#import "SDBOperation.h"

@interface SDBListDomains : SDBOperation

- (id)initWithMaxNumberOfDomains:(int)max nextToken:(NSString *)next;

@end

