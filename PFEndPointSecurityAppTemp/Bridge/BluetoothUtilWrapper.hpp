//
//  BluetoothUtilWrapper.h
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/25.
//

#ifndef BluetoothUtilWrapper_h
#define BluetoothUtilWrapper_h

#import <Cocoa/Cocoa.h>
#import <string>
#import <vector>
#import <map>

class JDCBluetoothUtil
{
public:
    JDCBluetoothUtil();
    ~JDCBluetoothUtil();

    typedef void (*BluetoothChangeCallBack)(const std::string &, const std::string &, int, int);
    static bool GetPowerState();
    static void SetPower(bool _bPowerOn);   // 특수한 경우 외 사용을 안하는게 좋을 듯...
};

@interface objcClass : NSObject

- (bool)GetPowerState;
- (void)SetPower:(bool)_bPowerOn;

@end

#endif /* BluetoothUtilWrapper_h */
