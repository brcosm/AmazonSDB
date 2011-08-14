
#import "AppDelegate.h"
#import "APIKey.h"

@interface AppDelegate() {
    //SDBOperation *currentOperation;
    int selectorIndex;
    NSArray *selectors_;
}
@end

@implementation AppDelegate

@synthesize window = _window;

#pragma mark - Example Code

- (NSDictionary *)exampleItem {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:@"1" forKey:@"Attribute1"];
    [attributes setValue:@"2" forKey:@"Attribute2"];
    [attributes setValue:@"three" forKey:@"Attribute3"];
    return [NSDictionary dictionaryWithDictionary:attributes];
}

- (NSDictionary *)exampleItems {
    NSMutableDictionary *items = [NSMutableDictionary dictionary];
    [items setValue:[self exampleItem] forKey:@"Item4"];
    [items setValue:[self exampleItem] forKey:@"Item5"];
    [items setValue:[self exampleItem] forKey:@"Item6"];
    return [NSDictionary dictionaryWithDictionary:items];
}

- (void)createNewDomain {
    [SDB createDomain:@"Tester" dataDelegate:self];
}

- (void)deleteDomain {
    [SDB deleteDomain:@"Tester" dataDelegate:self]; 
}

- (void)putItem1 {
    [SDB putItem:@"Item1" withAttributes:[self exampleItem] domain:@"Tester" dataDelegate:self];
}

- (void)putItem2 {
    [SDB putItem:@"Item2" withAttributes:[self exampleItem] domain:@"Tester" dataDelegate:self];
}

- (void)putItem3 {
    [SDB putItem:@"Item3" withAttributes:[self exampleItem] domain:@"Tester" dataDelegate:self];
}

- (void)batchPutItems {
    [SDB putItems:[self exampleItems] domain:@"Tester" dataDelegate:self];
}

- (void)listItems {
    [SDB selectWithExpression:@"select * from Tester" dataDelegate:self];
}

- (void)getItem {
    [SDB getItem:@"Item1" withAttributes:[NSArray arrayWithObjects:@"Attribute1", @"Attribute2", nil] domain:@"Tester" dataDelegate:self];
}

- (void)deleteItem {
    [SDB deleteItem:@"Item1" withAttributes:nil domain:@"Tester" dataDelegate:self];
}

- (void)batchDeleteItems {
    [SDB deleteItems:[self exampleItems] domain:@"Tester" dataDelegate:self];
}

/**
 Example/Test for all SDBOperations
 */

- (void)sdbExample {
    if ([SECRET_KEY isEqualToString:@""] || [ACCESS_KEY isEqualToString:@""]) {
        NSLog(@"Add your API keys to APIKey.h");
        exit(0);
    }
    selectorIndex = 0;
    selectors_ = [NSArray arrayWithObjects:
                  [NSValue valueWithPointer:@selector(createNewDomain)], 
                  [NSValue valueWithPointer:@selector(putItem1)],
                  [NSValue valueWithPointer:@selector(putItem2)],
                  [NSValue valueWithPointer:@selector(putItem3)],
                  [NSValue valueWithPointer:@selector(batchPutItems)],
                  [NSValue valueWithPointer:@selector(listItems)], 
                  [NSValue valueWithPointer:@selector(getItem)], 
                  [NSValue valueWithPointer:@selector(deleteItem)], 
                  [NSValue valueWithPointer:@selector(listItems)],
                  [NSValue valueWithPointer:@selector(batchDeleteItems)],
                  [NSValue valueWithPointer:@selector(listItems)],
                  nil];
    [self deleteDomain];
}

#pragma mark - SDB Delegate

- (void)didReceiveSDBData:(NSDictionary *)sdbData fromOperation:(SDBOperation *)operation {
    selectorIndex++;
    NSLog(@"Got data from %@:\n%@",operation.class, sdbData);
    if (selectorIndex <= selectors_.count) {
        SEL nextOperation = [[selectors_ objectAtIndex:selectorIndex-1] pointerValue];
        [self performSelector:nextOperation];
    }
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