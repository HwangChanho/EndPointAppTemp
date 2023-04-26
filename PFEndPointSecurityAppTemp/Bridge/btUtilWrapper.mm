//
//  btUtilWrapper.m
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/04/26.
//

#import "btUtilWrapper.h"
#include "btUtil.hpp"

@interface CPPWrapper()
@property JDCBluetoothUtil *cppItem;
@end

@implementation CPPWrapper

- (bool)GetPowerState
{
    return self.cppItem->GetPowerState();
}

- (void)SetPower:(bool)_bPowerOn
{
    self.cppItem->SetPower(_bPowerOn);
}

@end


