//
//  btUtilWrapper.h
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/04/26.
//

#ifndef btUtilWrapper_hpp
#define btUtilWrapper_hpp

#import <Foundation/Foundation.h>

@interface CPPWrapper : NSObject

- (bool)GetPowerState;
- (void)SetPower:(bool)_bPowerOn;

@end

#endif /* btUtilWrapper_h */
