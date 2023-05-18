//
//  btUtil.cpp
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/04/26.
//

#include "btUtil.hpp"

extern "C"
{
    int IOBluetoothPreferenceGetControllerPowerState();
    void IOBluetoothPreferenceSetControllerPowerState(int _nState);
}

bool JDCBluetoothUtil::GetPowerState()
{
    return IOBluetoothPreferenceGetControllerPowerState();
}

void JDCBluetoothUtil::SetPower(bool _bPowerOn)
{
    IOBluetoothPreferenceSetControllerPowerState(_bPowerOn);
}
