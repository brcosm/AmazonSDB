
#import "SDBAction.h"

@interface SDBListDomains : SDBAction

- (id)initWithMaxNumberOfDomains:(int)max NextToken:(NSString *)next;

@end

