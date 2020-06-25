#import "StoreCriticalDataPlugin.h"
#if __has_include(<store_critical_data/store_critical_data-Swift.h>)
#import <store_critical_data/store_critical_data-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "store_critical_data-Swift.h"
#endif

@implementation StoreCriticalDataPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStoreCriticalDataPlugin registerWithRegistrar:registrar];
}
@end
