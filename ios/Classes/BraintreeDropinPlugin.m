#import "BraintreeDropinPlugin.h"
#import <braintree_dropin/braintree_dropin-Swift.h>

@implementation BraintreeDropinPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBraintreeDropinPlugin registerWithRegistrar:registrar];
}
@end
