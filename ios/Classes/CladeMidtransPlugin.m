#import "CladeMidtransPlugin.h"
#import <clade_midtrans/clade_midtrans-Swift.h>

@implementation CladeMidtransPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCladeMidtransPlugin registerWithRegistrar:registrar];
}
@end
