
#import "SDBOperation.h"

@interface SDBListDomains : SDBOperation

- (id)initWithMaxNumberOfDomains:(int)max nextToken:(NSString *)next;

@end

