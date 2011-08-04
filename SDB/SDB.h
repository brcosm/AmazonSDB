
#import "SDBOperation.h"
#import "SDBListDomains.h"
#import "SDBDomainMetadata.h"
#import "SDBSelect.h"

@protocol SDBDataDelegate

- (void)didReceiveSDBData:(NSDictionary *)sdbData;

@end

@interface SDB : NSObject <NSURLConnectionDataDelegate>

@property (weak, nonatomic) id<SDBDataDelegate> dataDelegate;

+ (void)selectWithExpression:(NSString *)expression dataDelegate:(id<SDBDataDelegate>)dataDelegate;
+ (void)listDomainsWithMaximum:(int)max dataDelegate:(id<SDBDataDelegate>)dataDelegate;
+ (void)metadataForDomain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate;

@end