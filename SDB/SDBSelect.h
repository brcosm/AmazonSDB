
#import "SDBOperation.h"

@interface SDBSelect : SDBOperation

- (id)initWithExpression:(NSString *)expression NextToken:(NSString *)next;

@end
