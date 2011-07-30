
#import "SDBDomainMetadata.h"

@implementation SDBDomainMetadata

- (id)initWithDomainName:(NSString *)domainName {
    self = [super init];
    if (self) {
        [_parameters setValue:@"DomainMetadata" forKey:@"Action"];
        [_parameters setValue:[NSString stringWithString:domainName] forKey:@"DomainName"];
    }
    return self;
}

@end