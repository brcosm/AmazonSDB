
#import "SDBOperation.h"

@interface SDBSelect : SDBOperation

- (id)initWithExpression:(NSString *)expression nextToken:(NSString *)next;

@end
