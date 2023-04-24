//
//  Util.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/04/20.
//

import Cocoa
import Foundation
import IOKit

enum RootVolumePath {
    static let rootVolumePath = "file:///Volumes/"
    static let rootVolumePathLen = 16
    
    static let devicePath = "NSDevicePath"
}

enum IOKitKeys {
    static let serialNumber: CFString = "Serial Number" as CFString
    static let usbSerialNumber: CFString = "USB Serial Number" as CFString
}

func setTextViewText(_ textView: NSTextView, _ text: String, _ textViewLineCount: Int) -> Int {
    let lineCountToString = String(textViewLineCount)
    textView.textStorage?.append(NSAttributedString(string: lineCountToString + " ::  " + text + "\n"))
    
    if let textLength = textView.textStorage?.length {
        textView.textStorage?.setAttributes([.foregroundColor: NSColor.white, .font: NSFont.systemFont(ofSize: 13)], range: NSRange(location: 0, length: textLength))
    }
    
    return textViewLineCount + 1
}

func krReturnToString (_ kr: kern_return_t) -> String {
    if let cStr = mach_error_string(kr) {
        return String (cString: cStr)
    } else {
        return "Unknown kernel error \(kr)"
    }
}

// Disk
func getExternalVolumeNameList(keys: URLResourceKeyOptions) -> [String] {
    let filemanager = FileManager()
    let paths = filemanager.mountedVolumeURLs(includingResourceValuesForKeys: keys.keys, options: .produceFileReferenceURLs)
    var externalStorageVolumeNameArr: [String] = []
    var removableVolumeNameArr: [String] = []
    
    if let urls = paths as? [NSURL] {
        for url in urls {
            var isInternal: AnyObject?
            do {
                let _: () = try url.getResourceValue(&isInternal, forKey: keys.forKey)
                
                if isInternal == nil {
                    continue
                } else {
                    guard let volumeName = url.lastPathComponent else { return [] }
                    if isInternal as! Bool == false {
                        externalStorageVolumeNameArr.append(volumeName)
                    } else {
                        removableVolumeNameArr.append(volumeName)
                    }
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    return keys == .externalStorage ? externalStorageVolumeNameArr : removableVolumeNameArr
}

func isExistExternalVolumeName(strVolumeName: String) -> Bool {
    for volumeName in getExternalVolumeNameList(keys: .externalStorage) {
        if strVolumeName.compare(volumeName) == .orderedSame {
            return true
        }
    }
    
    return false
}

func getVolumePath(_ volumeName: String) -> String {
    return volumeName == "" ? "" :  RootVolumePath.rootVolumePath + String(volumeName)
}

func getDiskFromVolume(_ volumePath: String) -> String {
    let defaultOpt = kCFAllocatorDefault
    
    guard let session = DASessionCreate(defaultOpt) else { return "" }
    guard let path = CFURLCreateWithString(nil, volumePath as CFString?, nil) else { return "" }
    guard let disk = DADiskCreateFromVolumePath(defaultOpt, session, path) else { return "" }
    guard let BSDName = DADiskGetBSDName(disk) else { return "" }
    
    return String(cString: BSDName)
}

func getDADiskFromeVolume(_ volumeName: String) -> DADisk? {
    let defaultOpt = kCFAllocatorDefault
    let volumePath = getVolumePath(volumeName)
    
    guard let session = DASessionCreate(defaultOpt) else { return nil }
    
    DASessionScheduleWithRunLoop(session, CFRunLoopGetMain(), CFRunLoopMode.commonModes?.rawValue ?? "" as CFString)
    
    guard let cfVolume = CFStringCreateWithCString(defaultOpt, volumePath, CFStringBuiltInEncodings.UTF8.rawValue) else { return nil }
    guard let cfPath = CFURLCreateWithString(nil, cfVolume, nil) else { return nil }
    guard let daDisk = DADiskCreateFromVolumePath(defaultOpt, session, cfPath) else { return nil }
    
    return daDisk
}

func unMountDisk(_ volumePath: String) -> Bool {
    let defaultOpt = kCFAllocatorDefault
    
    guard let session = DASessionCreate(defaultOpt) else { return false }
    
    DASessionScheduleWithRunLoop(session, CFRunLoopGetMain(), CFRunLoopMode.commonModes?.rawValue ?? "" as CFString)
    
    guard let cfVolume = CFStringCreateWithCString(defaultOpt, volumePath, CFStringBuiltInEncodings.UTF8.rawValue) else { return false }
    guard let cfPath = CFURLCreateWithString(nil, cfVolume, nil) else { return false }
    guard let daDisk = DADiskCreateFromVolumePath(defaultOpt, session, cfPath) else { return false }
    
    DADiskEject(daDisk, DADiskEjectOptions(kDADiskMountOptionDefault), nil, nil)
    
    var isSucceed = true
    DADiskUnmount(daDisk, DADiskEjectOptions(kDADiskMountOptionDefault), unMountDone, &isSucceed)
    DASessionUnscheduleFromRunLoop(session, CFRunLoopGetMain(), CFRunLoopMode.commonModes?.rawValue ?? "" as CFString)
    
    return isSucceed
}

func unMountDone(_ daDisk: DADisk, _ daDissenter: DADissenter?, _ pContext: UnsafeMutableRawPointer?) -> () {
    if (daDissenter != nil) {
        // 재정의 필요 성공시 isSucceed로 들어온다.
        
    }
    print("pointer? ::", pContext?.load(as: Bool.self))
    print("unMount? ::", daDissenter)
}

func setMountCallBack(_ completionHandler: @escaping (Any?) -> Void) -> Bool {
    let mountObserver = NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didMountNotification, object: nil, queue: OperationQueue.main) { notification in
        guard let userInfo = notification.userInfo else { return }
        
        _ = userInfo[NSWorkspace.volumeURLUserInfoKey]
        let devicePath = userInfo[RootVolumePath.devicePath]
        
        completionHandler(devicePath ?? nil)
    }
    
    //    if mountObserver == nil {
    //        return false
    //    }
    
    return true
}

func setUnMountCallBack(_ completionHandler: @escaping (Any?) -> Void) -> Bool  {
    let unMountObserver = NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didUnmountNotification, object: nil, queue: OperationQueue.main) { notification in
        guard let userInfo = notification.userInfo else { return }
        guard let volumeUrl = userInfo[NSWorkspace.volumeURLUserInfoKey] as? NSURL else { return }
        
        let volumeName = volumeUrl.lastPathComponent
        let devicePath = userInfo[RootVolumePath.devicePath]
        
        if !isExistExternalVolumeName(strVolumeName: volumeName ?? "") {
            
        }
        
        completionHandler(devicePath ?? nil)
    }
    
    //    if unMountObserver == nil {
    //        return false
    //    }
    
    return true
}

func getDiskInfo(_ volumeName: String) -> CFDictionary? {
    guard let daDisk = getDADiskFromeVolume(volumeName) else { return nil }
    
    guard let dictDADisk = DADiskCopyDescription(daDisk) else { return nil }
    
    return dictDADisk
}

func getSerialNumber(_ volumeName: String) -> String {
    guard let daDisk = getDADiskFromeVolume(volumeName) else { return "" }
    
    let ioDevice = DADiskCopyIOMedia(daDisk)
    var ioParentIterator = io_iterator_t()
    
    let krReturn: kern_return_t = IORegistryEntryCreateIterator(ioDevice, kIOServicePlane, IOOptionBits(kIORegistryIterateRecursively | kIORegistryIterateParents), &ioParentIterator)
    
    IOObjectRelease(ioDevice)
    
    if krReturn != KERN_SUCCESS {
        return ""
    }
    
    var strSerialNumber = ""
    var ioParentDevice = io_service_t()
    
    while true {
        if ioParentDevice != 0 {
            break
        }
        
        ioParentDevice = IOIteratorNext(ioParentIterator)
        
        var cfParentProperty: Unmanaged<CFMutableDictionary>?
        
        if IORegistryEntryCreateCFProperties(ioParentDevice, &cfParentProperty, kCFAllocatorDefault, 0) == KERN_SUCCESS {
            
            var cfSerialNumber = IORegistryEntryCreateCFProperty(ioParentDevice, IOKitKeys.usbSerialNumber, kCFAllocatorDefault, 0)
            
            if cfSerialNumber == nil {
                cfSerialNumber = IORegistryEntryCreateCFProperty(ioParentDevice, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0)
            } else {
                strSerialNumber = getStringFromCFTypeRef(cfSerialNumber)
            }
            
            if strSerialNumber.isEmpty == false {
                break;
            }
        }
    }
//    print("serial Num ::", strSerialNumber)
    return strSerialNumber
}

func getStringFromCFTypeRef(_ cfTypeRef: Unmanaged<CFTypeRef>?) -> String {
    guard let cTR = cfTypeRef else { return "" }
    
    var bytes = [Character]()
    bytes.append("\0")
    let uint8Pointer = UnsafeMutablePointer<Character>.allocate(capacity: bytes.count)
    uint8Pointer.initialize(from: &bytes, count: bytes.count)
    
    if CFStringGetTypeID() == CFGetTypeID(cTR as! CFString) {
        CFStringGetCString((cTR as! CFString), uint8Pointer, CFIndex(PATH_MAX), CFStringBuiltInEncodings.UTF8.rawValue)
    }
}

func addExternalVolumeName() {
    
}
