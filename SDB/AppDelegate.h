

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDataDelegate> {
    NSMutableData *responseData;
}

@property (strong, nonatomic) UIWindow *window;

@end
