
#import "AppDelegate.h"
#import "APIKey.h"
#import "SDB.h"

@implementation AppDelegate

@synthesize window = _window;

#pragma mark - Example Code

/*
 The following methods provide a simple example of how to use
 AmazonSDB to perform the ListDomains operation.
 */

- (void)sdbExample {
    if ([SECRET_KEY isEqualToString:@""] || [ACCESS_KEY isEqualToString:@""])
        NSLog(@"Add your API keys to APIKey.h");
        exit(0);
    SDBAction *action = [[SDBListDomains alloc] initWithMaxNumberOfDomains:10 NextToken:nil];
    NSURL *sdbUrl = [NSURL URLWithString:action.signedUrlString];
    NSURLRequest *sdbReq = [NSURLRequest requestWithURL:sdbUrl];
    NSURLConnection *sdbConn = [NSURLConnection connectionWithRequest:sdbReq delegate:self];
    if (sdbConn)
        NSLog(@"Performing ListDomains Operation on %@ endpoint with version %@", action.regionEndPoint, action.version);
    else 
        NSLog(@"Unable to initialize connection; check action parameters");
}

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
    NSLog(@"Here is the xml from SDB:\n%@", responseString);
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