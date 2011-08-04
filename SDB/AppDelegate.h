
#import "SDB.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SDBDataDelegate> {
    NSMutableData *responseData;
}

@property (strong, nonatomic) UIWindow *window;

@end
