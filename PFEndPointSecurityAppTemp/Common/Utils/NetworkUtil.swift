//
//  NetworkUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/15.
//

import Foundation
import SystemConfiguration

let HARDWARE               = "Hardware"
let HARDWARE_ETHERNET      = "Ethernet"
let HARDWARE_AIR_PORT      = "AirPort"
let HARDWARE_MODEM         = "Modem"
let HARDWARE_THUNDERBOLT   = "Thunderbolt"
let LEFT_CURLY_BRAKET      = "{"
let COMMA_SPACE            = ", "

let INTERFACE_APPLE_WIRELESS_DIRECT_LINK   = "awdl"
let INTERFACE_FIRE_WIRE                    = "fw"
let INTERFACE_BRIDGE                       = "vmenet"

let SERVICE_USB                            = "USB"
let SERVICE_BLUETOOTH_PAN                  = "Bluetooth PAN"

let STATE_NETWORK_GLOBAL_IPV4          = "State:/Network/Global/IPv4"
let STATE_NETWORK_INTERFACE_ALL_LINK   = "State:/Network/Interface/[^/]+/Link"
let PRIMARY_INTERFACE                  = "PrimaryInterface"

let SETUP_NETWORK_GLOBAL_IPV4         = "Setup:/Network/Global/IPv4"
let NETWORK_INTERFACE_DETECTOR        = "NetworkInterfaceDetector"
let LOOP_BACK_INTERFACE               = "lo"
let NETWORK_INTERFACE_ACTIVE          = "Network Interface Active"

class NetworkUtil: NSObject {
    static let shared = NetworkUtil()
    private override init() {}
    
    func getAllNicInfo() -> NSArray? {
        return CFBridgingRetain(SCNetworkInterfaceCopyAll()) as? NSArray
    }
    
    func getActiveNicName(_ vActiveNicName: inout [String]) -> Bool {
        vActiveNicName.removeAll()
        
        do {
            guard let scStore: SCDynamicStore = SCDynamicStoreCreate(nil, NETWORK_INTERFACE_ACTIVE as CFString, nil, nil) else {
                return false
            }
            
            let cfInterfaces: CFString = SCDynamicStoreKeyCreateNetworkInterface(nil, kSCDynamicStoreDomainState)
            let cfPropList: CFDictionary = SCDynamicStoreCopyValue(scStore, cfInterfaces) as! CFDictionary
            let cfNetInterfaces: CFArray = CFDictionaryGetValue(cfPropList, unsafeBitCast(kSCDynamicStorePropNetInterfaces, to: UnsafeRawPointer.self)) as! CFArray
            
            for i in 0..<CFArrayGetCount(cfNetInterfaces) {
                let cfInterFace: CFString = CFArrayGetValueAtIndex(cfNetInterfaces, i) as! CFString
                if CFStringFind(cfInterfaces, LOOP_BACK_INTERFACE as CFString, CFStringCompareFlags.compareAnchored).location != kCFNotFound {
                    continue
                }
                
                let cfKey: CFString = SCDynamicStoreKeyCreateNetworkInterfaceEntity(nil, kSCDynamicStoreDomainState, cfInterFace, kSCEntNetLink)
                let cfLinkDic = SCDynamicStoreCopyValue(scStore, cfKey)
                
                if cfLinkDic == nil {
                    continue
                }
                let pszInterfaeName: UnsafeMutablePointer<CChar>?
                CFStringGetCString(cfInterFace, pszInterfaeName, CFIndex(PATH_MAX), CFStringBuiltInEncodings.UTF8.rawValue)
                let cfActive: CFBoolean = CFDictionaryGetValue(cfLinkDic as! CFDictionary, kSCPropNetLinkActive) as! CFBoolean
                if cfActive == kCFBooleanTrue {
                    vActiveNicName.append(String(pszInterfaeName))
                }
            }
        } catch {
            print("JDCNicUtil::GetActiveNicName Error =[%s]")
        }
        
        return true
    }
    
//    func getServiceInfo(_ strNicName: String) -> NSDictionary? {
//        if strNicName.isEmpty { return nil }
//
//
//    }
}
