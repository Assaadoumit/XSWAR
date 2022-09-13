
#import "GlobalFunction.h"
#import "CheckInternetReachability.h"

@implementation GlobalFunction

UIWindow *window;

+(BOOL)ISinternetConnection{
    CheckInternetReachability* reachability;
    reachability = [CheckInternetReachability reachabilityWithHostname:@"www.google.com"]; //change URL to application server
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    [reachability startNotifier];
    switch (netStatus) {
            
        case NotReachable:{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkFail" object:self];
            return NO;
            break;
        }
            
        case ReachableViaWWAN:{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkPass" object:self];
            return YES;
            break;
        }
        case ReachableViaWiFi:{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkPass" object:self];
            return YES;
            break;
        }
    }
}

+ (NSString *)getApplicationName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}




+(void)SaveValue :(NSString*) Value key :(NSString *) key{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:Value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+(NSString *)GetValueForkey :(NSString*) key{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *value = @"";
    if ([standardUserDefaults objectForKey:key]!= nil) {
        value =  [[standardUserDefaults objectForKey:key] mutableCopy];
        [standardUserDefaults synchronize];
    }
    return value;
}


+(NSMutableDictionary *)checkString:(NSString *)key dic:(NSMutableDictionary *)dic
{
    if ([[dic valueForKey:key]isKindOfClass:[NSNull class]]) {
         return dic;
    }
    else
    {
        return nil;
    }
}
@end
