
#import "AppDelegate.h"
#import "APIKey.h"

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
    [SDB selectWithExpression:@"select * from Menu limit 3" dataDelegate:self];
    [SDB metadataForDomain:@"Menu" dataDelegate:self];
    [SDB listDomainsWithMaximum:10 dataDelegate:self];
}

#pragma mark - SDB Delegate

- (void)didReceiveSDBData:(NSDictionary *)sdbData {
    NSLog(@"Got SDB data:\n%@",sdbData);
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