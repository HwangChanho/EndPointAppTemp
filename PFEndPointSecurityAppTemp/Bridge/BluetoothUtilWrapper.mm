//
//  BluetoothUtilWrapper.m
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/25.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

#import "BluetoothUtilWrapper.hpp"

extern "C"
{
    int IOBluetoothPreferenceGetControllerPowerState();
    void IOBluetoothPreferenceSetControllerPowerState(int _nState);
}

/**
 @brief     블루투스의 전원 상태를 가져 온다.
 @author    jungmyungjae
 @return    Power On(true)/Power Off(false)
 @date      2022.04.11
*/
bool JDCBluetoothUtil::GetPowerState()
{
    return IOBluetoothPreferenceGetControllerPowerState();
}

/**
 @brief     블루투스의 전원 상태를 설정 한다.
 @author    jungmyungjae
 @param     [in] _bPowerOn      Power On(true)/Power Off(false)
 @date      2022.04.11
*/
void JDCBluetoothUtil::SetPower(bool _bPowerOn)
{
    IOBluetoothPreferenceSetControllerPowerState(_bPowerOn);
}

