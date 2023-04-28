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

enum POLICY {
    static let KEY_SET_ODD_POLICY     = "set_odd_policy"
    static let KEY_SET_POLICY         = "set_policy"
    static let KEY_ADD_POLICY         = "add_policy"
    static let KEY_DEL_POLICY         = "del_policy"
    static let KEY_CLEAR_POLICY       = "clear_policy"
    static let KEY_POLICY_ITEM        = "policy_item"
}

enum PEPolicyKinds: Int {
    case OddPolicy = 0                         // ODD 정책
    case DenyProcessPath                       // 프로세스 경로로 프로세스 실행 차단
    case DenyProcessSignedId                   // 프로세스 서명 ID로 프로세스 실행 차단
    case CheckFileReadProcessPath              // 프로세스 경로의 해당 되는 프로세스의 파일 읽기를 체크한다
    case CheckFileReadProcessSignedId          // 프로세스 서명 ID의 해당 되는 프로세스의 파일 읽기를 체크한다
    case ExceptionPath                         // 예외 경로
    case MuteProcessPath                       // 음소거 프로세스 경로
    case ExternalStorageVolumePath             // 외부 저장소 경로
    case DenyDirecotryWithUsers                // 사용자 경로 하위의 차단 디렉토리
    case DenyCreateFileInDirectory             // 지정된 경로 하위의 파일 생성 차단
    case ProtectionPath                        // 경로 보호 ( 디렉토리 하위의 경로 모두 보호 )
    case ProtectionFilePath                    // 파일 보호
    case ProtectionProcessPath                 // 프로세스 경로로 프로세스 보호
    case ProtectionProcessSignedId             // 프로세스 서명 ID 로 프로세스 보호
    case ProtectionAcceptProcessPath           // 경로 보호, 파일 보호의 접근 할 수 있는 프로세스 경로
    case ProtectionAcceptProcessSignedId       // 경로 보호, 파일 보호의 접근 할 수 있는 프로세스 서명 ID
    case NotifyEventFlag                       // Notify 이벤트를 Auth 이벤트에서도 사용 할 경우의 대한 Flag
    case MonitoringModifiedFilePath            // 파일의 변경 여부를 감시 한다.
}


// MARK: Disk
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

func getDiskInfo(_ volumeName: String) -> NSDictionary? {
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

func addExternalVolumeName(_ path: String, _ vc: NSViewController) {
    let dictSentData = NSMutableDictionary()
    
    dictSentData.setObject(NSNumber(value: PEPolicyKinds.ExternalStorageVolumePath.rawValue), forKey: POLICY.KEY_ADD_POLICY as NSCopying)
    dictSentData.setObject(path, forKey: POLICY.KEY_ADD_POLICY as NSCopying)
    
    if vc != DiskViewController() {
        
    }
}

func sendClientData(_ dictSendData: NSDictionary) {
    let appID = "\(Constant.AppKey.APP_ID)_\(getpid())"
    
   
}


