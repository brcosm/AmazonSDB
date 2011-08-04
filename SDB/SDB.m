
#import "SDB.h"

@interface SDB() {
    SDBOperation *currentOperation_;
    NSMutableData *responseData_;
    id<SDBDataDelegate> dataDelegate_;
}

- (void)startRequest;

@end

@implementation SDB

- (id)initWithOperation:(SDBOperation *)operation andDataDelegate:(id<SDBDataDelegate>)dataDelegate {
    self = [super init];
    if (self) {
        currentOperation_ = operation;
        dataDelegate_ = dataDelegate;
    }
    return self;
}

- (void)startRequest {
    NSURL *sdbUrl = [NSURL URLWithString:currentOperation_.signedUrlString];
    NSURLRequest *sdbReq = [NSURLRequest requestWithURL:sdbUrl];
    NSURLConnection *sdbConn = [NSURLConnection connectionWithRequest:sdbReq delegate:self];
    if (sdbConn)
        NSLog(@"Performing Select Operation on %@ endpoint with version %@", currentOperation_.regionEndPoint, currentOperation_.version);
    else 
        NSLog(@"Unable to initialize connection; check action parameters");
}

+ (void)selectWithExpression:(NSString *)expression dataDelegate:(id<SDBDataDelegate>)dataDelegate {
    
    SDBOperation *operation = [[SDBSelect alloc] initWithExpression:@"Select * from Menu limit 3" nextToken:nil]; 
    SDB *sdb = [[SDB alloc] initWithOperation:operation andDataDelegate:dataDelegate];
    [sdb startRequest];
}

+ (void)listDomainsWithMaximum:(int)max dataDelegate:(id<SDBDataDelegate>)dataDelegate {
    SDBOperation *operation = [[SDBListDomains alloc] initWithMaxNumberOfDomains:max nextToken:nil]; 
    SDB *sdb = [[SDB alloc] initWithOperation:operation andDataDelegate:dataDelegate];
    [sdb startRequest];
}

+ (void)metadataForDomain:(NSString *)domain dataDelegate:(id<SDBDataDelegate>)dataDelegate {
    SDBOperation *operation = [[SDBDomainMetadata alloc] initWithDomainName:[NSString stringWithString:domain]];
    SDB *sdb = [[SDB alloc] initWithOperation:operation andDataDelegate:dataDelegate];
    [sdb startRequest];
}

- (void)setDataDelegate:(id<SDBDataDelegate>)dataDelegate {
    dataDelegate_ = dataDelegate;
}

- (id)dataDelegate {
    return dataDelegate_;
}

#pragma mark - Connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (!responseData_)
        responseData_ = [NSMutableData data];
    [responseData_ setLength:0];
    NSLog(@"SDB has responded to the request and is sending %lld bytes of data", response.expectedContentLength);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // The operation object parses the xml
    [currentOperation_ parseResponseData:responseData_];
    
    // The parsed data dictionary is sent to the delegate
    [self.dataDelegate didReceiveSDBData:[NSDictionary dictionaryWithDictionary:currentOperation_.responseDictionary]];
}


@end