//
//  OddUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/02.
//

import Foundation
import IOKit

enum OddUtil {
    static let BSD_NAME = "BSD Name" as CFString
}

class OddUtilManager: NSObject {
    static let shared = OddUtilManager()
    
    typealias OddStatusChangeCallBack = ((String) -> ())?
    typealias DADiskMountCallback = (DADisk, DADissenter?, UnsafeMutableRawPointer?) -> Void
    
    let m_pfConnectionCallBack: OddStatusChangeCallBack = nil
    let m_pfDisConnectCallBack: OddStatusChangeCallBack = nil
    
    func unMountDone(_ daDisk: DADisk, _ daDissenter: DADissenter?, _ pContext: UnsafeMutableRawPointer?) -> Void {
        var pIsSucceed: Bool = (UnsafeMutableRawPointer(pContext) != nil)
        
        if daDissenter != nil {
            pIsSucceed = false
            // log: unmountFailed
        }
    }
    
    func getBsdNameFromIOObject(_ ioDevice: io_object_t) -> String {
        if ioDevice == 0 { return "" }
        
        var strBsdName: String = ""
        var cfProperty: UnsafeMutablePointer<Unmanaged<CFMutableDictionary>?>?
        
        if IORegistryEntryCreateCFProperties(ioDevice, cfProperty, kCFAllocatorDefault, 0) == KERN_SUCCESS {
            let cfBsdName: CFTypeRef = IORegistryEntryCreateCFProperty(ioDevice, OddUtil.BSD_NAME, kCFAllocatorDefault, 0) as AnyObject
            strBsdName = getStringFromCFTypeRef(cfBsdName as? Unmanaged<CFTypeRef>)
        }
        
        return strBsdName
    }
    
    func getDADiskFromBsdName(_ strBsdName: String) -> DADisk? {
        if strBsdName.isEmpty == true { return nil }
        
        guard let daSession = DASessionCreate(kCFAllocatorDefault) else { return nil }
        let daDisk: DADisk? = DADiskCreateFromBSDName(kCFAllocatorDefault, daSession, strBsdName)
        
        return daDisk
    }
    
    func getSerialNumberOdd(_ strBsdName: String) -> String {
        if strBsdName.isEmpty { return "" }
        
        guard let daDisk = getDADiskFromBsdName(strBsdName) else { return "" }
        return getSerialNumber(daDisk as! String)
    }
    
    func fireConnectCallBack(_ strBsdName: String) {
        if m_pfConnectionCallBack != nil {
            m_pfConnectionCallBack!(strBsdName)
        }
    }
    
    func fireDisConnectCallBack(_ strBsdName: String) {
        if m_pfDisConnectCallBack != nil {
            m_pfDisConnectCallBack!(strBsdName)
        }
    }
    
    func getBsdNameListFromClassMatchService(_ ofClassMatchService: CFMutableDictionary, _ vBsdNameList: inout [String]) -> Bool {
        var machPortMaster = mach_port_t()
        var krReturn = kern_return_t()
        
        krReturn = IOMainPort(mach_port_t(MACH_PORT_NULL), &machPortMaster)
        if krReturn != KERN_SUCCESS || machPortMaster == 0 {
            return false
        }
        
        var ioIterator = io_iterator_t()
        krReturn = IOServiceGetMatchingServices(machPortMaster, ofClassMatchService, &ioIterator)
        if krReturn != KERN_SUCCESS {
            mach_port_deallocate(mach_task_self_, machPortMaster)
            return false
        }
        
        var ioNextDevice = io_object_t()
        
        while ioNextDevice != 0 {
            var strBsdName = getBsdNameFromIOObject(ioNextDevice)
            vBsdNameList.append(strBsdName)
            IOObjectRelease(ioNextDevice)
            ioNextDevice = IOIteratorNext(ioIterator)
        }
        IOObjectRelease(ioIterator)
        mach_port_deallocate(mach_task_self_, machPortMaster)
        
        return true
    }
    
    func getOddInfo(_ strBsdName: String) -> NSDictionary? {
        if strBsdName.isEmpty { return nil }
        
        guard let daSession = DASessionCreate(kCFAllocatorDefault) else { return nil }
        guard let daDisk = DADiskCreateFromBSDName(kCFAllocatorDefault, daSession, strBsdName) else { return nil }
        guard let cfDictDaDisk = DADiskCopyDescription(daDisk) else { return nil }
        
        return cfDictDaDisk
    }
    
    func eject(_ strBsdName: String) -> Bool {
        if strBsdName.isEmpty { return false }
        
        guard let daSession = DASessionCreate(kCFAllocatorDefault) else { return false }
        DASessionScheduleWithRunLoop(daSession, RunLoop.main.getCFRunLoop(), CFRunLoopMode.defaultMode!.rawValue)
        
        guard let daDisk = DADiskCreateFromBSDName(kCFAllocatorDefault, daSession, strBsdName) else { return false }
        DADiskEject(daDisk, DADiskEjectOptions(kDADiskEjectOptionDefault), nil, nil)
        var bIsSucceed = true
        
        DADiskUnmount(daDisk, DADiskUnmountOptions(kDADiskUnmountOptionDefault), { daDisk, daDissenter, pContext in
            var pIsSucceed: Bool = (UnsafeMutableRawPointer(pContext) != nil)
            
            if daDissenter != nil {
                pIsSucceed = false
                // log: unmountFailed
            }
        }, &bIsSucceed)
        DASessionUnscheduleFromRunLoop(daSession, RunLoop.main.getCFRunLoop(), CFRunLoopMode.defaultMode!.rawValue)
        
        return bIsSucceed
    }
    
    func getConnectBsdNameList(_ vBsdNameList: inout [String]) {
        vBsdNameList.removeAll()
        
        var cfIOServiceMachting: CFMutableDictionary? = nil
        
        cfIOServiceMachting = IOServiceMatching("IODVDMedia")
        if cfIOServiceMachting != nil {
            if getBsdNameListFromClassMatchService(cfIOServiceMachting!, &vBsdNameList) == false {
                print("IODVDMedia")
            }
        }
        
        cfIOServiceMachting = IOServiceMatching("IOCDMedia")
        if cfIOServiceMachting != nil {
            if getBsdNameListFromClassMatchService(cfIOServiceMachting!, &vBsdNameList) == false {
                print("IOCDMedia")
            }
        }
        
        cfIOServiceMachting = IOServiceMatching("IOBDMedia")
        if cfIOServiceMachting != nil {
            if getBsdNameListFromClassMatchService(cfIOServiceMachting!, &vBsdNameList) == false {
                print("IOBDMedia")
            }
        }
    }
}
