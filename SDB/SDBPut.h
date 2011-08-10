
#import "SDBOperation.h"

@interface SDBPut : SDBOperation

- (id)initWithItemName:(NSString *)item attributes:(NSDictionary *)attributes domainName:(NSString *)domain;

@end
