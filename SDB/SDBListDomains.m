
#import "SDBListDomains.h"

@implementation SDBListDomains

- (id)init {
    return [self initWithMaxNumberOfDomains:0 NextToken:nil];
}

- (id)initWithMaxNumberOfDomains:(int)max NextToken:(NSString *)next {
    self = [super init];
    if (self) {
        [_parameters setValue:@"ListDomains" forKey:@"Action"];
        if (max) [_parameters setValue:[NSString stringWithFormat:@"%d", max] forKey:@"MaxNumberOfDomains"];
        if (next) [_parameters setValue:[NSString stringWithFormat:@"%@", next] forKey:@"NextToken"];
    }
    return self;
}

@end
