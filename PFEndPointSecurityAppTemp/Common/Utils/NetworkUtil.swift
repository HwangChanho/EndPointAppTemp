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
    
    private var m_cfRunLoopSourceRef: CFRunLoopSource?
    
    func setNicStatusChangeCallBack() -> Bool {
        var scContext = SCDynamicStoreContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        
        let arrMonitoringInterfaceKeys = [NetworkNameSpace.STATE_NETWORK_GLOBAL_IPV4]
        let arrPatterns = [NetworkNameSpace.STATE_NETWORK_INTERFACE_ALL_LINK]
        
        guard let m_scStoreRef = SCDynamicStoreCreate(nil, NetworkNameSpace.NETWORK_INTERFACE_DETECTOR.rawValue as CFString, { scDynamicStore, cfChangeKeys, pInfo in
            
            var strInterfaceName: [NSString] = []
            let nCount = CFArrayGetCount(cfChangeKeys)
            
            for i in 1..<nCount {
                let cfKey = CFArrayGetValueAtIndex(cfChangeKeys, i)
                let cfPropertyList = SCDynamicStoreCopyValue(scDynamicStore, cfKey as! CFString)
                let dicPropertyList: NSDictionary = cfPropertyList as! NSDictionary
                let interfaceName = dicPropertyList.object(forKey: NetworkNameSpace.PRIMARY_INTERFACE.rawValue)
                if interfaceName != nil {
                    guard let interfaceName else { return }
                    let strData = Unmanaged<NSString>.fromOpaque(interfaceName as! UnsafeRawPointer).takeUnretainedValue()
                    
                    strInterfaceName.append(strData)
                }
            }
            print(strInterfaceName)
            // 로그를 전역적으로 셋팅해서 뿌릴수있는 모듈을 만들어서 사용해야할듯..
            
        }, &scContext) else { return false }
        
        SCDynamicStoreSetNotificationKeys(m_scStoreRef, arrMonitoringInterfaceKeys as CFArray, arrPatterns as CFArray)
        m_cfRunLoopSourceRef = SCDynamicStoreCreateRunLoopSource(nil, m_scStoreRef, 0)
        if m_cfRunLoopSourceRef == nil {
            return false
        }
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(), m_cfRunLoopSourceRef, CFRunLoopMode.defaultMode)
        
        return true
    }
    
    func setPower(on: Bool, of nicName: String) -> Bool {
        let socket = socket(AF_INET, SOCK_DGRAM, 0)
        
        var stIfr = ifreq()
        
        guard let ifNameSize = Int(nicName) else { return false }
        var b = [CChar] (repeating: 0, count: ifNameSize)
        strncpy (&b, nicName, ifNameSize)
        
        stIfr.ifr_name = (b [0], b [1], b [2], b [3], b [4], b [5], b [6], b [7], b [8], b [9], b [10], b [11], b [12], b [13], b [14], b [15])
        
        if on {
            stIfr.ifr_ifru.ifru_flags |= 0x1
        } else {
            stIfr.ifr_ifru.ifru_flags &= ~0x1
        }
        
        let nResult = ioctl(socket, 16)
        
        if nResult < 0 {
             return false
        }
        
        return true
    }
    
    func getAllNicInfo() -> NSArray? {
        return CFBridgingRetain(SCNetworkInterfaceCopyAll()) as? NSArray
    }
    
    func getServiceInfo(_ nicName: String) -> NSDictionary? {
        guard let scStore: SCDynamicStore = SCDynamicStoreCreate(nil, NetworkNameSpace.NETWORK_INTERFACE_ACTIVE.rawValue as CFString, nil, nil) else { return nil }
        
        let cfGlobalPropList: CFDictionary = SCDynamicStoreCopyValue(scStore, NetworkNameSpace.SETUP_NETWORK_GLOBAL_IPV4.rawValue as CFString) as! CFDictionary
        let cfGlobalInterfaces = ((cfGlobalPropList as NSDictionary)["ServiceOrder"] as! NSArray)
        
        for item in cfGlobalInterfaces {
            let cfKey: CFString = SCDynamicStoreKeyCreateNetworkServiceEntity(nil, kSCDynamicStoreDomainSetup, item as! CFString, kSCEntNetInterface)
            
            let cfServiceDic: CFDictionary = (SCDynamicStoreCopyValue(scStore, cfKey) as! CFDictionary)
            if let cfInterfaceName = ((cfServiceDic as NSDictionary)["DeviceName"]) {

                if nicName == cfInterfaceName as! String {
                    return cfServiceDic as NSDictionary
                }
            } else {
                continue
            }
        }
        
        return nil
    }
    
    func getServiceName(_ nicName: String, _ completion: @escaping (String) -> ()) -> Bool {
        guard let scStore: SCDynamicStore = SCDynamicStoreCreate(nil, NetworkNameSpace.NETWORK_INTERFACE_ACTIVE.rawValue as CFString, nil, nil) else { return false }
        
        let cfGlobalPropList: CFDictionary = SCDynamicStoreCopyValue(scStore, NetworkNameSpace.SETUP_NETWORK_GLOBAL_IPV4.rawValue as CFString) as! CFDictionary
        let cfGlobalInterfaces = ((cfGlobalPropList as NSDictionary)["ServiceOrder"] as! NSArray)
        
        for item in cfGlobalInterfaces {
            let cfKey: CFString = SCDynamicStoreKeyCreateNetworkServiceEntity(nil, kSCDynamicStoreDomainSetup, item as! CFString, kSCEntNetInterface)
            let cfServiceDic: CFDictionary = (SCDynamicStoreCopyValue(scStore, cfKey) as! CFDictionary)
            
            if let cfInterfaceName = ((cfServiceDic as NSDictionary)["DeviceName"]) {
                if nicName == cfInterfaceName as! String {
                    let cfServiceName = ((cfServiceDic as NSDictionary)["UserDefinedName"])
                    
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
    
    func getActiveNicName(_ completion: @escaping ([String]) -> ()) -> Bool {
        guard let scStore: SCDynamicStore = SCDynamicStoreCreate(nil, NetworkNameSpace.NETWORK_INTERFACE_ACTIVE.rawValue as CFString, nil, nil) else {
            return false
        }
        
        let cfInterfaces: CFString = SCDynamicStoreKeyCreateNetworkInterface(nil, kSCDynamicStoreDomainState)
        let cfPropList: CFDictionary = SCDynamicStoreCopyValue(scStore, cfInterfaces) as! CFDictionary
        let cfNetInterfaces = (cfPropList as NSDictionary)["Interfaces"] as! NSArray
        
        var itemArr: [String] = []
        
        for item in cfNetInterfaces {
            if CFStringFind((item as! CFString), NetworkNameSpace.LOOP_BACK_INTERFACE.rawValue as CFString, CFStringCompareFlags.compareAnchored).location != kCFNotFound {
                continue
            }
            
            let cfKey: CFString = SCDynamicStoreKeyCreateNetworkInterfaceEntity(nil, kSCDynamicStoreDomainState, item as! CFString, kSCEntNetLink)
            let cfLinkDic = SCDynamicStoreCopyValue(scStore, cfKey)
            
            if cfLinkDic == nil {
                continue
            }
            
            let cfActive: CFBoolean = (cfLinkDic as! NSDictionary)["Active"] as! CFBoolean
            
            if CFBooleanGetValue(cfActive) == true {
                itemArr.append(item as! String)
            }
        }
        
        if !itemArr.isEmpty {
            completion(itemArr)
        }
        
        return true
    }
    
    //    func getServiceInfo(_ strNicName: String) -> NSDictionary? {
    //        if strNicName.isEmpty { return nil }
    //
    //
    //    }
}
