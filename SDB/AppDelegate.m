
#import "AppDelegate.h"
#import "APIKey.h"
#import "SDB.h"

@interface AppDelegate() {
    SDBOperation *currentOperation;
}
@end

@implementation AppDelegate

@synthesize window = _window;

#pragma mark - Example Code

/**
 The following is a simple example of how to use
 AmazonSDB to perform the Select operation.
 */

- (void)sdbExample {
    if ([SECRET_KEY isEqualToString:@""] || [ACCESS_KEY isEqualToString:@""]) {
        NSLog(@"Add your API keys to APIKey.h");
        exit(0);
    }
    //currentOperation = [[SDBSelect alloc] initWithExpression:@"Select * from Menu" NextToken:nil];
    currentOperation = [[SDBListDomains alloc] initWithMaxNumberOfDomains:10 NextToken:nil];
    //currentOperation = [[SDBDomainMetadata alloc] initWithDomainName:@"Menu"];
    NSURL *sdbUrl = [NSURL URLWithString:currentOperation.signedUrlString];
    NSURLRequest *sdbReq = [NSURLRequest requestWithURL:sdbUrl];
    NSURLConnection *sdbConn = [NSURLConnection connectionWithRequest:sdbReq delegate:self];
    if (sdbConn)
        NSLog(@"Performing Select Operation on %@ endpoint with version %@", currentOperation.regionEndPoint, currentOperation.version);
    else 
        NSLog(@"Unable to initialize connection; check action parameters");
}

#pragma mark - Connection Delegate for Example

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (!responseData)
        responseData = [NSMutableData data];
    [responseData setLength:0];
    NSLog(@"SDB has responded to the request and is sending %lld bytes of data", response.expectedContentLength);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Received xml from SDB:\n%@\nParsing this data...", responseString);
    [currentOperation parseResponseData:responseData];
    NSLog(@"Completed data parse:\n%@",currentOperation.responseDictionary);
}

#pragma mark - App Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self sdbExample];
    return YES;
}

@end