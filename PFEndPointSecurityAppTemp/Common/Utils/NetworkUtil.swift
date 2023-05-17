//
//  NetworkUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/15.
//

import Foundation
import SystemConfiguration
import Network

enum NetworkNameSpace: String {
    case HARDWARE               = "Hardware"
    case HARDWARE_ETHERNET      = "Ethernet"
    case HARDWARE_AIR_PORT      = "AirPort"
    case HARDWARE_MODEM         = "Modem"
    case HARDWARE_THUNDERBOLT   = "Thunderbolt"
    case LEFT_CURLY_BRAKET      = "{"
    case COMMA_SPACE            = ", "
    
    case INTERFACE_APPLE_WIRELESS_DIRECT_LINK   = "awdl"
    case INTERFACE_FIRE_WIRE                    = "fw"
    case INTERFACE_BRIDGE                       = "vmenet"
    
    case SERVICE_USB                            = "USB"
    case SERVICE_BLUETOOTH_PAN                  = "Bluetooth PAN"
    
    case STATE_NETWORK_GLOBAL_IPV4          = "State:/Network/Global/IPv4"
    case STATE_NETWORK_INTERFACE_ALL_LINK   = "State:/Network/Interface/[^/]+/Link"
    case PRIMARY_INTERFACE                  = "PrimaryInterface"
    
    case SETUP_NETWORK_GLOBAL_IPV4         = "Setup:/Network/Global/IPv4"
    case NETWORK_INTERFACE_DETECTOR        = "NetworkInterfaceDetector"
    case LOOP_BACK_INTERFACE               = "lo"
    case NETWORK_INTERFACE_ACTIVE          = "Network Interface Active"
}

class NetworkUtil: NSObject {
    static let shared = NetworkUtil()
    private override init() {}
    
    func setPower(on: Bool, of nicName: String) -> Bool {
        let nSockfd: Int = Int(socket(AF_INET, SOCK_DGRAM, 0))
        let stIfr: ifreq?
        let bytes = nicName.utf8CString
        var arr: [UInt8] = []
        
        typealias TupleType = (CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar)
        
        bytes.forEach {
            arr.append(UInt8($0))
        }
        
        if nSockfd < 0 { return false }
        
        var tuple = UnsafeMutablePointer<TupleType>.allocate(capacity: 16)
        memcpy(tuple, arr, Int(UInt(arr.count)))
        
        stIfr?.ifr_name = tuple
        
        print(bytes[0])
    }
    
    func getAllNicInfo() -> NSArray? {
        return CFBridgingRetain(SCNetworkInterfaceCopyAll()) as? NSArray
    }
    
    func getServiceInfo(_ nicName: String) -> NSDictionary? {
        guard let scStore: SCDynamicStore = SCDynamicStoreCreate(nil, NetworkNameSpace.NETWORK_INTERFACE_ACTIVE.rawValue as CFString, nil, nil) else { return nil }
        
        let cfGlobalInterfaces: CFArray?
        let cfGlobalPropList: CFDictionary = SCDynamicStoreCopyValue(scStore, NetworkNameSpace.SETUP_NETWORK_GLOBAL_IPV4.rawValue as CFString) as! CFDictionary
        cfGlobalInterfaces = ((cfGlobalPropList as NSDictionary)["ServiceOrder"] as! CFArray)
        
        for index in 1...CFArrayGetCount(cfGlobalInterfaces) {
            let cfGlobalInterface: CFString = unsafeBitCast(CFArrayGetValueAtIndex(cfGlobalInterfaces, index), to: CFString.self)
            let cfKey: CFString = SCDynamicStoreKeyCreateNetworkServiceEntity(nil, kSCDynamicStoreDomainSetup, cfGlobalInterface, kSCEntNetInterface)
            
            let cfServiceDic: CFDictionary = (SCDynamicStoreCopyValue(scStore, cfKey) as! CFDictionary)
            if let cfInterfaceName = ((cfServiceDic as NSDictionary)["DeviceName"]) {
                let pszInterfaceName = UnsafeMutablePointer<CChar>.allocate(capacity: CFStringGetLength((cfInterfaceName as! CFString)) + 1)
                CFStringGetCString((cfInterfaceName as! CFString), pszInterfaceName, CFStringGetLength((cfInterfaceName as! CFString)) + 1, CFStringBuiltInEncodings.UTF8.rawValue)
                let strName = String(cString: pszInterfaceName)
                
                if nicName == strName {
                    return cfServiceDic
                }
            } else {
                continue
            }
        }
        
        return nil
    }
    
    func getServiceName(_ nicName: String, _ completion: @escaping (String) -> ()) -> Bool {
        guard let scStore: SCDynamicStore = SCDynamicStoreCreate(nil, NetworkNameSpace.NETWORK_INTERFACE_ACTIVE.rawValue as CFString, nil, nil) else { return false }
        
        let cfGlobalInterfaces: CFArray?
        let cfGlobalPropList: CFDictionary = SCDynamicStoreCopyValue(scStore, NetworkNameSpace.SETUP_NETWORK_GLOBAL_IPV4.rawValue as CFString) as! CFDictionary
        cfGlobalInterfaces = ((cfGlobalPropList as NSDictionary)["ServiceOrder"] as! CFArray)
        
        for index in 1...CFArrayGetCount(cfGlobalInterfaces) {
            let cfGlobalInterface: CFString = unsafeBitCast(CFArrayGetValueAtIndex(cfGlobalInterfaces, index), to: CFString.self)
            let cfKey: CFString = SCDynamicStoreKeyCreateNetworkServiceEntity(nil, kSCDynamicStoreDomainSetup, cfGlobalInterface, kSCEntNetInterface)
            
            let cfServiceDic: CFDictionary = (SCDynamicStoreCopyValue(scStore, cfKey) as! CFDictionary)
            if let cfInterfaceName = ((cfServiceDic as NSDictionary)["DeviceName"]) {
                let pszInterfaceName = UnsafeMutablePointer<CChar>.allocate(capacity: CFStringGetLength((cfInterfaceName as! CFString)) + 1)
                CFStringGetCString((cfInterfaceName as! CFString), pszInterfaceName, CFStringGetLength((cfInterfaceName as! CFString)) + 1, CFStringBuiltInEncodings.UTF8.rawValue)
                let strName = String(cString: pszInterfaceName)
                
                if nicName == strName {
                    let cfServiceName = ((cfServiceDic as NSDictionary)["UserDefinedName"])
                    let pszServiceName = UnsafeMutablePointer<CChar>.allocate(capacity: CFStringGetLength((cfServiceName as! CFString)) + 1)
                    CFStringGetCString((cfServiceName as! CFString), pszServiceName, CFStringGetLength((cfServiceName as! CFString)) + 1, CFStringBuiltInEncodings.UTF8.rawValue)
                    
                    completion(cfServiceName as! String)
                    break
                }
            } else {
                continue
            }
        }
        
        return true
    }
    
    func getAllNicInfoKeyValue() -> String {
        guard let arrNicInfo: NSArray = getAllNicInfo() else { return "" }
        var arr: [String] = []
        
        for info in arrNicInfo {
            let nicInfo: NSString = NSString(format: "%@", info as! CVarArg)
            
            if !nicInfo.contains(NetworkNameSpace.LEFT_CURLY_BRAKET.rawValue) {
                return info as! String
            }
            
            let range = nicInfo.range(of: NetworkNameSpace.LEFT_CURLY_BRAKET.rawValue)
            
            let parseInfo = nicInfo.substring(with: NSMakeRange(range.location + 1, nicInfo.length - (range.location + 2)))
            let listItems: NSArray = parseInfo.components(separatedBy: NetworkNameSpace.COMMA_SPACE.rawValue) as NSArray
            
            for item in listItems {
                let newItem: NSString = item as! NSString
                let keyValue: NSArray = newItem.components(separatedBy: "=") as NSArray
                let value: NSString = (keyValue.object(at: 1) as AnyObject).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
                let key: NSString = (keyValue.object(at: 0) as AnyObject).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
                
                arr.append("Key=[\(key)], Value=[\(value)]\n")
            }
        }
        
        return arr.joined()
    }
    
    func getActiveNicName(_ completion: @escaping (String) -> ()) -> Bool {
        guard let scStore: SCDynamicStore = SCDynamicStoreCreate(nil, NetworkNameSpace.NETWORK_INTERFACE_ACTIVE.rawValue as CFString, nil, nil) else {
            return false
        }
        
        let cfInterfaces: CFString = SCDynamicStoreKeyCreateNetworkInterface(nil, kSCDynamicStoreDomainState)
        let cfPropList: CFDictionary = SCDynamicStoreCopyValue(scStore, cfInterfaces) as! CFDictionary
        let cfNetInterfaces = (cfPropList as NSDictionary)["Interfaces"] as! CFArray
        
        for i in 1...CFArrayGetCount(cfNetInterfaces) {
            let cfInterFace: CFString = unsafeBitCast(CFArrayGetValueAtIndex(cfNetInterfaces, i), to: CFString.self)
            if CFStringFind(cfInterFace, NetworkNameSpace.LOOP_BACK_INTERFACE.rawValue as CFString, CFStringCompareFlags.compareAnchored).location != kCFNotFound {
                continue
            }
            
            let cfKey: CFString = SCDynamicStoreKeyCreateNetworkInterfaceEntity(nil, kSCDynamicStoreDomainState, cfInterFace, kSCEntNetLink)
            let cfLinkDic = SCDynamicStoreCopyValue(scStore, cfKey)
            
            if cfLinkDic == nil {
                continue
            }
            
            let pszInterfaceName = UnsafeMutablePointer<CChar>.allocate(capacity: Int(PATH_MAX) + 1)
            CFStringGetCString(cfInterFace, pszInterfaceName, CFIndex(PATH_MAX), CFStringBuiltInEncodings.UTF8.rawValue)
            let cfActive: CFBoolean = (cfLinkDic as! NSDictionary)["Active"] as! CFBoolean
            if cfActive == kCFBooleanTrue {
                let str = String(cString: pszInterfaceName)
                completion(str)
            }
        }
        
        return true
    }
    
    //    func getServiceInfo(_ strNicName: String) -> NSDictionary? {
    //        if strNicName.isEmpty { return nil }
    //
    //
    //    }
}
