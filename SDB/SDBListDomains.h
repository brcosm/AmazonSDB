
#import "SDBOperation.h"

@interface SDBListDomains : SDBOperation

- (id)initWithMaxNumberOfDomains:(int)max NextToken:(NSString *)next;

@end

