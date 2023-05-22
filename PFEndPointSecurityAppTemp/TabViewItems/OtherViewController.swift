//
//  OtherViewController.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/22.
//

import Cocoa

let LAUNCHCTL_PATH                     = "/bin/launchctl"
let LAUNCHCTL_UNLOAD_CMD               = "/bin/launchctl unload"
let LAUNCHCTL_LOAD_CMD                 = "/bin/launchctl load"
let LAUNCHCTL_BOOT_OUT_CMD             = "/bin/launchctl bootout gui/"
let LAUNCHCTL_BOOT_STRAP_CMD           = "/bin/launchctl bootstrap gui/"
let CLOUD_STORAGE_PHONE_MECHANIC_PATH  = "/Library/CloudStorage/PhoneMechanic"
let SPOOL_CUPS_PATH                    = "/private/var/spool/cups/"

let DOCK_PROC_PATH                     = "/System/Library/CoreServices/Dock.app/Contents/XPCServices/com.apple.dock.extra.xpc/Contents/MacOS/com.apple.dock.extra"

let APPLE_CAMERA_APPS: [PFSAppInfo] = [
    PFSAppInfo("com.apple.applecamerad", "/usr/sbin/applecamerad", "/System/Library/LaunchDaemons/com.apple.applecamerad.plist"),
    PFSAppInfo("com.apple.appleh13camerad", "/usr/sbin/appleh13camerad", "/System/Library/LaunchDaemons/com.apple.appleh13camerad.plist"),
    PFSAppInfo("com.apple.avconferenced", "/usr/libexec/avconferenced", "/System/Library/LaunchAgents/com.apple.avconferenced.plist")
]

let MOBILE_DEVICE_APPS: [PFSAppInfoShort] = [
    PFSAppInfoShort("com.apple.amp.devicesui", "/System/Library/PrivateFrameworks/AMPDevices.framework/Versions/A/XPCServices/com.apple.amp.devicesui.xpc/Contents/MacOS/com.apple.amp.devicesui"),
    PFSAppInfoShort("com.google.android.mtpviewer", "/Applications/Android File Transfer.app/Contents/MacOS/Android File Transfer"),
    PFSAppInfoShort("com.99mobileapp.filemanager", "/Applications/My Files for Samsung Galaxy.app/Contents/MacOS/My Files for Samsung Galaxy"),
    PFSAppInfoShort("app.ilia.McDroid", "/Applications/McDroid.app/Contents/MacOS/McDroid"),
    PFSAppInfoShort("de.canyumusak.androiddrop", "/Applications/AnDrop.app/Contents/MacOS/AnDrop"),
    PFSAppInfoShort("com.huawei.hisuite", "/Applications/hisuite.app/Contents/MacOS/hisuite"),
]

class OtherViewController: NSViewController {
    @IBOutlet var textView: NSTextView!
    
    @IBOutlet weak var cameraProcPathCheckBox: NSButton!
    @IBOutlet weak var cameraProcSignedldCheckBox: NSButton!
    @IBOutlet weak var MDProcPathCheckBox: NSButton!
    @IBOutlet weak var MDProcSignedldCheckBox: NSButton!
    
    private var textViewLineCount = 0
    
    let PFCommonManager = PFCommonUtil.shared
    let processManager = ProcessUtil.shared
    let XPCCommunicationManager = FileNotificationXPCAppCommunication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func cameraDaemonUnload(_ sender: NSButton) {
        if getpid() != 0 && geteuid() != 0 {
            setLog("Permission denied")
            return
        }
        
        if PFCommonManager.verifyAppleFile(LAUNCHCTL_PATH) {
            setLog("not verify /bin/launchctl")
            return
        }
        
        for i in 0..<APPLE_CAMERA_APPS.count {
            let cameraUnloadCmd = "\(LAUNCHCTL_UNLOAD_CMD) \(String(describing: APPLE_CAMERA_APPS[i].plistPath))"
            let _ = PFCommonManager.executeCommand(cameraUnloadCmd)
        }
        
        var vDockPidList: [pid_t] = []
        vDockPidList = processManager.getProcessPIDs(for: DOCK_PROC_PATH)
        for nPid in vDockPidList {
            let nUid = processManager.getUID(nPid)
            let avconferencedBootOutCmd = "\(LAUNCHCTL_BOOT_OUT_CMD)\(String(describing: nUid)) \(String(describing: APPLE_CAMERA_APPS[2].plistPath))"
            
            let _ = PFCommonManager.executeCommand(avconferencedBootOutCmd)
        }
        
        setLog("CameraDaemonUnloadButtonClick")
    }
    
    
    @IBAction func cameraDaemonLoad(_ sender: NSButton) {
        if getpid() != 0 && geteuid() != 0 {
            setLog("Permission denied")
            return
        }
        
        if PFCommonManager.verifyAppleFile(LAUNCHCTL_PATH) {
            setLog("not verify /bin/launchctl")
            return
        }
        
        for i in 0..<APPLE_CAMERA_APPS.count {
            let cameraUnloadCmd = "\(LAUNCHCTL_LOAD_CMD) \(String(describing: APPLE_CAMERA_APPS[i].plistPath))"
            let _ = PFCommonManager.executeCommand(cameraUnloadCmd)
        }
        
        var vDockPidList: [pid_t] = []
        vDockPidList = processManager.getProcessPIDs(for: DOCK_PROC_PATH)
        for nPid in vDockPidList {
            let nUid = processManager.getUID(nPid)
            let avconferencedBootOutCmd = "\(LAUNCHCTL_BOOT_STRAP_CMD)\(String(describing: nUid)) \(String(describing: APPLE_CAMERA_APPS[2].plistPath))"
            
            let _ = PFCommonManager.executeCommand(avconferencedBootOutCmd)
        }
        
        setLog("CameraDaemonLoadButtonClick")
    }
    
    @IBAction func deny(_ sender: NSButton) {
        if cameraProcPathCheckBox.state == .on {
            if cameraProcessPathDeny() == true {
                setLog("Add CameraProcessPathDeny Succeeded")
            } else {
                setLog("Add CameraProcessPathDeny Failed!!!")
            }
        }
        
        if cameraProcSignedldCheckBox.state == .on {
            if cameraProcessSignedIdDeny() == true {
                setLog("Add CameraProcessSignedIdDeny Succeeded")
            } else {
                setLog("Add CameraProcessSignedIdDeny Failed!!!")
            }
        }
        
        if MDProcPathCheckBox.state == .on {
            if mobileDeviceProcessPathDeny() == true {
                setLog("Add MobileDeviceProcessPathDeny Succeeded")
            } else {
                setLog("Add MobileDeviceProcessPathDeny Failed!!!")
            }
        }
        
        if MDProcSignedldCheckBox.state == .on {
            if mobileDeviceProcessSignedIdDeny() == true {
                setLog("Add MobileDeviceProcessSignedIdDeny Succeeded")
            } else {
                setLog("Add MobileDeviceProcessSignedIdDeny Failed!!!")
            }
        }
    }
    
    @IBAction func allow(_ sender: NSButton) {
        if cameraProcPathCheckBox.state == .on {
            if cameraProcessPathAllow() == true {
                setLog("Del CameraProcessPathDeny Succeeded")
            } else {
                setLog("Del CameraProcessPathDeny Failed!!!")
            }
        }
        
        if cameraProcSignedldCheckBox.state == .on {
            if cameraProcessSignedIdAllow() == true {
                setLog("Del CameraProcessSignedIdDeny Succeeded")
            } else {
                setLog("Del CameraProcessSignedIdDeny Failed!!!")
            }
        }
        
        if MDProcPathCheckBox.state == .on {
            if mobileDeviceProcessPathAllow() == true {
                setLog("Del MobileDeviceProcessPathDeny Succeeded")
            } else {
                setLog("Del MobileDeviceProcessPathDeny Failed!!!")
            }
        }
        
        if MDProcSignedldCheckBox.state == .on {
            if mobileDeviceProcessSignedIdAllow() == true {
                setLog("Del MobileDeviceProcessSignedIdDeny Succeeded")
            } else {
                setLog("Del MobileDeviceProcessSignedIdDeny Failed!!!")
            }
        }
    }
    
    @IBAction func denyDirectoryWithUsers(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.DenyDirecotryWithUsers.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        dictSendData.setObject(CLOUD_STORAGE_PHONE_MECHANIC_PATH, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            setLog("Add DenyDirectoryWithUsers CLOUD_STORAGE_PATH Failed !!!")
            return
        }
        
        setLog("Add DenyDirectoryWithUsers CLOUD_STORAGE_PATH")
    }
    
    @IBAction func allowDirectoryWithUsers(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.DenyDirecotryWithUsers.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        dictSendData.setObject(CLOUD_STORAGE_PHONE_MECHANIC_PATH, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            setLog("Del DenyDirectoryWithUsers CLOUD_STORAGE_PATH Failed !!!")
            return
        }
        
        setLog("Del DenyDirectoryWithUsers CLOUD_STORAGE_PATH")
    }
    
    @IBAction func networkPrintDeny(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.DenyDirecotryWithUsers.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        dictSendData.setObject(SPOOL_CUPS_PATH, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            setLog("Add DenyCreateFileInDirectory SPOOL_CUPS_PATH Failed !!!")
            return
        }
        
        setLog("Add DenyCreateFileInDirectory SPOOL_CUPS_PATH")
    }
    
    @IBAction func networkPrintAllow(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.DenyDirecotryWithUsers.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        dictSendData.setObject(SPOOL_CUPS_PATH, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            setLog("Del DenyCreateFileInDirectory SPOOL_CUPS_PATH Failed !!!")
            return
        }
        
        setLog("Del DenyCreateFileInDirectory SPOOL_CUPS_PATH")
    }
    
    private func setLog(_ text: String) {
        textViewLineCount = setTextViewText(self.textView, text, textViewLineCount)
        self.textView.scrollToEndOfDocument(self)
    }
}

extension OtherViewController {
    func cameraProcessPathDeny() -> Bool {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<APPLE_CAMERA_APPS.count {
            dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.DenyProcessPath.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(APPLE_CAMERA_APPS[i].procPath!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add DenyProcessPath \(String(describing: APPLE_CAMERA_APPS[i].procPath)) Failed !!!")
                return false
            }
            
            if processManager.killAllProcess(APPLE_CAMERA_APPS[i].procPath! as String) {
                setLog("Can't killed \(String(describing: APPLE_CAMERA_APPS[i].procPath)) !!!")
                return false
            }
            
            setLog("Add DenyProcessPath \(String(describing: APPLE_CAMERA_APPS[i].procPath))")
        }
        
        return true
    }
    
    func cameraProcessPathAllow() -> Bool {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<APPLE_CAMERA_APPS.count {
            dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.DenyProcessPath.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(APPLE_CAMERA_APPS[i].procPath!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Del DenyProcessPath \(String(describing: APPLE_CAMERA_APPS[i].procPath)) Failed !!!")
                return false
            }
            
            setLog("Del DenyProcessPath \(String(describing: APPLE_CAMERA_APPS[i].procPath))")
        }
        
        return true
    }
    
    func cameraProcessSignedIdDeny() -> Bool {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<APPLE_CAMERA_APPS.count {
            dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.DenyProcessSignedId.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(APPLE_CAMERA_APPS[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add DenyProcessSignedID \(String(describing: APPLE_CAMERA_APPS[i].signedID)) Failed !!!")
                return false
            }
            
            if processManager.killAllProcess(APPLE_CAMERA_APPS[i].procPath! as String) {
                setLog("Can't killed \(String(describing: APPLE_CAMERA_APPS[i].procPath)) !!!")
                return false
            }
            
            setLog("Add DenyProcessSignedID \(String(describing: APPLE_CAMERA_APPS[i].signedID))")
        }
        
        return true
    }
    
    func cameraProcessSignedIdAllow() -> Bool {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<APPLE_CAMERA_APPS.count {
            dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.DenyProcessSignedId.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(APPLE_CAMERA_APPS[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Del DenyProcessSignedID \(String(describing: APPLE_CAMERA_APPS[i].signedID)) Failed !!!")
                return false
            }
            
            setLog("Del DenyProcessSignedID \(String(describing: APPLE_CAMERA_APPS[i].signedID))")
        }
        
        return true
    }
    
    func mobileDeviceProcessPathDeny() -> Bool {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<MOBILE_DEVICE_APPS.count {
            dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.DenyProcessPath.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(MOBILE_DEVICE_APPS[i].procPath!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add DenyProcessPath \(String(describing: MOBILE_DEVICE_APPS[i].procPath)) Failed !!!")
                return false
            }
            
            if processManager.killAllProcess(MOBILE_DEVICE_APPS[i].procPath! as String) {
                setLog("Can't killed \(String(describing: MOBILE_DEVICE_APPS[i].procPath)) !!!")
                return false
            }
            
            setLog("Add DenyProcessPath \(String(describing: MOBILE_DEVICE_APPS[i].procPath))")
        }
        
        return true
    }
    
    func mobileDeviceProcessPathAllow() -> Bool {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<MOBILE_DEVICE_APPS.count {
            dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.DenyProcessPath.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(MOBILE_DEVICE_APPS[i].procPath!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Del DenyProcessPath \(String(describing: MOBILE_DEVICE_APPS[i].procPath)) Failed !!!")
                return false
            }
            
            setLog("Del DenyProcessPath \(String(describing: MOBILE_DEVICE_APPS[i].procPath))")
        }
        
        return true
    }
    
    func mobileDeviceProcessSignedIdDeny() -> Bool {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<MOBILE_DEVICE_APPS.count {
            dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.DenyProcessSignedId.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(MOBILE_DEVICE_APPS[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add DenyProcessSignedID \(String(describing: MOBILE_DEVICE_APPS[i].signedID)) Failed !!!")
                return false
            }
            
            if processManager.killAllProcess(MOBILE_DEVICE_APPS[i].procPath! as String) {
                setLog("Can't killed \(String(describing: MOBILE_DEVICE_APPS[i].procPath)) !!!")
                return false
            }
            
            setLog("Add DenyProcessSignedID \(String(describing: MOBILE_DEVICE_APPS[i].signedID))")
        }
        
        return true
    }
    
    func mobileDeviceProcessSignedIdAllow() -> Bool {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<MOBILE_DEVICE_APPS.count {
            dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.DenyProcessSignedId.rawValue), forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(MOBILE_DEVICE_APPS[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Del DenyProcessSignedID \(String(describing: MOBILE_DEVICE_APPS[i].signedID)) Failed !!!")
                return false
            }
            
            setLog("Del DenyProcessSignedID \(String(describing: MOBILE_DEVICE_APPS[i].signedID))")
        }
        
        return true
    }
}
