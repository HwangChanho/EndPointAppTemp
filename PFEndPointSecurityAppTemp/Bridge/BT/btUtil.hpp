//
//  btUtil.hpp
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/04/26.
//

#ifndef btUtil_hpp
#define btUtil_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include <map>

class JDCBluetoothUtil {
public:
    JDCBluetoothUtil();
    ~JDCBluetoothUtil();
    
    static bool GetPowerState();
    static void SetPower(bool _bPowerOn);   // 특수한 경우 외 사용을 안하는게 좋을 듯...
};

#endif /* btUtil_hpp */
