//
//  BlockExecutionViewController.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/21.
//

import Cocoa



//    let APPLICATION_PATH         = "/Applications/"
let USERS_DIRECTORY          = "/Users/"
let APP_SEPARATOR            = ".app/"

let VIDEO_PLAYER_APP: [PFSAppInfoShort] = [
    PFSAppInfoShort("com.9bestapp.smartplay", "/Applications/SmartPlay.app/Contents/MacOS/SmartPlay"),
    PFSAppInfoShort("com.apple.QuickTimePlayerX", "/System/Applications/QuickTime Player.app/Contents/MacOS/QuickTime Player"),
    PFSAppInfoShort("com.eltima.elmedia6.mas", "/Applications/Elmedia Video Player.app/Contents/MacOS/Elmedia Video Player"),
    PFSAppInfoShort("com.firecore.infuse", "/Applications/Infuse.app/Contents/MacOS/Infuse"),
    PFSAppInfoShort("com.longhaiqiang.mac.SupremePlayer-Lite", "/Applications/SupremePlayer Lite.app/Contents/MacOS/SupremePlayer Lite"),
    PFSAppInfoShort("com.mac.utility.media.player", "/Applications/OmniPlayerStore.app/Contents/MacOS/OmniPlayerStore"),
    PFSAppInfoShort("com.mac.utility.video.player.PotPlayerX", "/Applications/PotPlayerX.app/Contents/MacOS/PotPlayerX"),
    PFSAppInfoShort("com.oecoway.friendlynetflix", "/Applications/Friendly Streaming.app/Contents/MacOS/Friendly Streaming"),
    PFSAppInfoShort("com.rockysandstudio.MKPlayer", "/Applications/MKPlayer.app/Contents/MacOS/MKPlayer"),
    PFSAppInfoShort("com.shedworx.SmartPlayer", "/Applications/Smart Player.app/Contents/MacOS/Smart Player"),
    PFSAppInfoShort("com.FinalVideoPlayer.FinalVideoPlayer", "/Applications/Final Video Player.app/Contents/MacOS/Final Video Player"),
    PFSAppInfoShort("max.video.player", "/Applications/MX Player HD.app/Contents/MacOS/MX Player HD"),
]

let WEB_HARD_APP: [PFSAppInfoFlags] = [
    PFSAppInfoFlags("com.shift.todiskmac", "/Applications/TodiskDownMac.app/Contents/MacOS/TodiskDownMac", 0x1, false),
    PFSAppInfoFlags("com.winpeople.filebogo", "/Applications/filebogo.app/Contents/MacOS/filebogo", 0x1, false),
    PFSAppInfoFlags("www.filemaru.com.FileMaru", "/Applications/FileMaru.app/Contents/MacOS/FileMaru", 0x1, false),
    PFSAppInfoFlags("kr.co.webhard.macwebhard", "/Applications/WebHard Explorer.app/Contents/MacOS/WebHard Explorer", 0x1, true),
]

let SCREEN_CAPTURE_APP: [PFSAppInfoShort] = [
    PFSAppInfoShort("com.apple.screencapture", "/usr/sbin/screencapture"),
    PFSAppInfoShort("com.buildtoconnect.screenrecorder", "/Applications/Record It.app/Contents/MacOS/Record It"),
    PFSAppInfoShort("com.getfireshot.fireshot", "/Applications/FireShot - Full web page screenshots.app/Contents/MacOS/FireShot - Full web page screenshots"),
    PFSAppInfoShort("com.linebreak.CloudAppMacOSX", "/Applications/CloudApp.app/Contents/MacOS/CloudApp"),
    PFSAppInfoShort("com.mac.utility.screen.recorder", "/Applications/OmniRecorder.app/Contents/MacOS/OmniRecorder"),
    PFSAppInfoShort("com.mahtca.macos.snip-my", "/Applications/Snip My.app/Contents/MacOS/Snip My"),
    PFSAppInfoShort("com.screenshot.iscreenshoter", "/Applications/iScreen Shoter 2022.app/Contents/MacOS/iScreen Shoter 2022"),
    PFSAppInfoShort("com.Apowersoft.ScreenshotFree", "/Applications/Apowersoft Screenshot.app/Contents/MacOS/Apowersoft Screenshot"),
    PFSAppInfoShort("ro.nextwave.Snappy", "/Applications/Snappy.app/Contents/MacOS/Snappy"),
]

let REMOTE_CONTROL_APP: [PFSAppInfoFlags] = [
    PFSAppInfoFlags("com.apple.ScreenSharing", "/System/Library/CoreServices/Applications/Screen Sharing.app/Contents/MacOS/Screen Sharing", 0x01, false),
    PFSAppInfoFlags("com.apple.SSFileCopySenderFW", "/System/Library/PrivateFrameworks/ScreenSharing.framework/Versions/A/Resources/SSFileCopySenderFW", 0x01, true),
    PFSAppInfoFlags("com.midassoft.ezHelpClient", "/Applications/ezHelpClient.app/Contents/MacOS/ezHelpClient", 0x01, true),
    PFSAppInfoFlags("com.philandro.anydesk", "/Applications/AnyDesk.app/Contents/MacOS/AnyDesk", 0x01, true),
    PFSAppInfoFlags("midassoft.ezHelp", "/Applications/ezHelp.app/Contents/MacOS/ezHelp", 0x01, true),
]

class BlockExecutionViewController: NSViewController {
    @IBOutlet var textView: NSTextView!
    
    private var textViewLineCount = 0
    
    let pathUtilManager = PathUtil.shared
    let processUtilManager = ProcessUtil.shared
    let XPCCommunicationManager = FileNotificationXPCAppCommunication.shared
    let systemManager = SystemSecurityAndPrivacyUtil.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func webBrowser(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        dictSendData.setObject(PolicyKinds.DenyProcessSignedId, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
        
        for i in 0..<WEB_BROWER_APP.count {
            let strProcPath = WEB_BROWER_APP[i].procPath
            let strProcName = pathUtilManager.getFileName(strProcPath! as String)
            processUtilManager.killAllProcess(strProcName)
            
            dictSendData.setObject(WEB_BROWER_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add Deny Process Signed Id \(String(describing: WEB_BROWER_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Deny Process Signed Id, WebBrowser")
    }
    
    @IBAction func messenger(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<MESSENGER_APP.count {
            let strProcPath = MESSENGER_APP[i].procPath
            let strProcName = pathUtilManager.getFileName(strProcPath! as String)
            processUtilManager.killAllProcess(strProcName)
            
            dictSendData.setObject(PolicyKinds.DenyProcessSignedId, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(MESSENGER_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add Deny Process Signed Id \(String(describing: MESSENGER_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Deny Process Signed Id, Messenger")
    }
    
    @IBAction func ftp(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<FTP_APP.count {
            let strProcPath = FTP_APP[i].procPath
            let strProcName = pathUtilManager.getFileName(strProcPath! as String)
            processUtilManager.killAllProcess(strProcName)
            
            dictSendData.setObject(PolicyKinds.DenyProcessSignedId, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(FTP_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add Deny Process Signed Id \(String(describing: FTP_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Deny Process Signed Id, FTP")
    }
    
    @IBAction func videoPlayer(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<VIDEO_PLAYER_APP.count {
            let strProcPath = VIDEO_PLAYER_APP[i].procPath
            let strProcName = pathUtilManager.getFileName(strProcPath! as String)
            processUtilManager.killAllProcess(strProcName)
            
            dictSendData.setObject(PolicyKinds.DenyProcessSignedId, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(VIDEO_PLAYER_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add Deny Process Signed Id \(String(describing: VIDEO_PLAYER_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Deny Process Signed Id, Video Player")
    }
    
    @IBAction func webHard(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<WEB_HARD_APP.count {
            let strProcPath = WEB_HARD_APP[i].procPath
            let strProcName = pathUtilManager.getFileName(strProcPath! as String)
            processUtilManager.killAllProcess(strProcName)
            
            dictSendData.setObject(PolicyKinds.DenyProcessSignedId, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(WEB_HARD_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add Deny Process Signed Id \(String(describing: WEB_HARD_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Deny Process Signed Id, Web Hard")
    }
    
    @IBAction func mail(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<MAIL_APP.count {
            let strProcPath = MAIL_APP[i].procPath
            let strProcName = pathUtilManager.getFileName(strProcPath! as String)
            processUtilManager.killAllProcess(strProcName)
            
            dictSendData.setObject(PolicyKinds.DenyProcessSignedId, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(MAIL_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add Deny Process Signed Id \(String(describing: MAIL_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Deny Process Signed Id, Mail")
    }
    
    @IBAction func cloud(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<CLOUD_STORAGE_APP.count {
            let strProcPath = CLOUD_STORAGE_APP[i].procPath
            let strProcName = pathUtilManager.getFileName(strProcPath! as String)
            processUtilManager.killAllProcess(strProcName)
            
            dictSendData.setObject(PolicyKinds.DenyProcessSignedId, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(CLOUD_STORAGE_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add Deny Process Signed Id \(String(describing: CLOUD_STORAGE_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Deny Process Signed Id, Cloud Storage")
    }
    
    @IBAction func screenCapture(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<SCREEN_CAPTURE_APP.count {
            let strProcPath = SCREEN_CAPTURE_APP[i].procPath
            let strProcName = pathUtilManager.getFileName(strProcPath! as String)
            processUtilManager.killAllProcess(strProcName)
            
            dictSendData.setObject(PolicyKinds.DenyProcessSignedId, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(SCREEN_CAPTURE_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add Deny Process Signed Id \(String(describing: SCREEN_CAPTURE_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Deny Process Signed Id, ScreenCapture")
    }
    
    @IBAction func screenCapture_mon(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.MonitoringModifiedFilePath, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
        dictSendData.setObject(TCC_DB_PATH, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
        
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            setLog("Add Monitoring File \(TCC_DB_PATH) Failed !!!")
            return
        }
        
        dictSendData.setObject(TCC_DB_PATH_, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
        if XPCCommunicationManager.sendClientData(dictSendData) == false {
            setLog("Add Monitoring File \(TCC_DB_PATH) Failed !!!")
            return
        }
        
        //        modifiedTccDB()
    }
    
    @IBAction func remoteControl(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<REMOTE_CONTROL_APP.count {
            let strProcPath = REMOTE_CONTROL_APP[i].procPath
            let strProcName = pathUtilManager.getFileName(strProcPath! as String)
            processUtilManager.killAllProcess(strProcName)
            
            dictSendData.setObject(PolicyKinds.DenyProcessSignedId, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(REMOTE_CONTROL_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add Deny Process Signed Id \(String(describing: REMOTE_CONTROL_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Deny Process Signed Id, Remote Control")
    }
    
    // MARK: - Read Check
    @IBAction func webBrowerDeny(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.CheckFileReadProcessSignedId, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        
        for i in 0..<WEB_BROWSER_FILE_READ_SIGNED_ID.count {
            dictSendData.setObject(WEB_BROWSER_FILE_READ_SIGNED_ID[i], forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add File Read Deny Process Signed Id \(WEB_BROWSER_FILE_READ_SIGNED_ID[i]) Failed !!!")
                return
            }
        }
        
        setLog("Add File Read Deny, WebBrowser")
    }
    
    @IBAction func messengerDeny(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.CheckFileReadProcessSignedId, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        
        for i in 0..<MESSENGER_APP.count {
            dictSendData.setObject(MESSENGER_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add File Read Deny Process Signed Id \(String(describing: MESSENGER_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add File Read Deny, Messenger")
    }
    
    @IBAction func ftpDeny(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.CheckFileReadProcessSignedId, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        
        for i in 0..<FTP_APP.count {
            dictSendData.setObject(FTP_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(NSNumber(integerLiteral: FTP_APP[i].nFileFlag!), forKey: EndPointNameSpace.KEY_FFLAG as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add File Read Deny Process Signed Id \(String(describing: FTP_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add File Read Deny, FTP")
    }
    
    @IBAction func cloudStorageDeny(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        dictSendData.setObject(PolicyKinds.CheckFileReadProcessSignedId, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        
        for i in 0..<CLOUD_STORAGE_APP.count {
            dictSendData.setObject(CLOUD_STORAGE_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(NSNumber(integerLiteral: CLOUD_STORAGE_APP[i].nFileFlag!), forKey: EndPointNameSpace.KEY_FFLAG as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add File Read Deny Process Signed Id \(String(describing: CLOUD_STORAGE_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add File Read Deny, CludStorage")
    }
    
    @IBAction func mailDeny(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        dictSendData.setObject(PolicyKinds.CheckFileReadProcessSignedId, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        
        for i in 0..<MAIL_APP.count {
            if MAIL_APP[i].bIsFileReadDeny == false { continue }
            
            dictSendData.setObject(MAIL_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(NSNumber(integerLiteral: MAIL_APP[i].nFileFlag!), forKey: EndPointNameSpace.KEY_FFLAG as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add File Read Deny Process Signed Id \(String(describing: MAIL_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add File Read Deny, Mail")
    }
    
    @IBAction func webHardDeny(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        dictSendData.setObject(PolicyKinds.CheckFileReadProcessSignedId, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        
        for i in 0..<WEB_HARD_APP.count {
            if WEB_HARD_APP[i].bIsFileReadDeny == false { continue }
            
            dictSendData.setObject(WEB_HARD_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(NSNumber(integerLiteral: WEB_HARD_APP[i].nFileFlag!), forKey: EndPointNameSpace.KEY_FFLAG as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add File Read Deny Process Signed Id \(String(describing: WEB_HARD_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add File Read Deny, WebHard")
    }
    
    @IBAction func remoteControlDeny(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        dictSendData.setObject(PolicyKinds.CheckFileReadProcessSignedId, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        
        for i in 0..<REMOTE_CONTROL_APP.count {
            if REMOTE_CONTROL_APP[i].bIsFileReadDeny == false { continue }
            
            dictSendData.setObject(REMOTE_CONTROL_APP[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            dictSendData.setObject(NSNumber(integerLiteral: REMOTE_CONTROL_APP[i].nFileFlag!), forKey: EndPointNameSpace.KEY_FFLAG as NSCopying)
            
            if XPCCommunicationManager.sendClientData(dictSendData) == false {
                setLog("Add File Read Deny Process Signed Id \(String(describing: REMOTE_CONTROL_APP[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add File Read Deny, RemoteControl")
    }
    
    private func setLog(_ text: String) {
        textViewLineCount = setTextViewText(self.textView, text, textViewLineCount)
        self.textView.scrollToEndOfDocument(self)
    }
    
    // MARK: - File Monitoring
    /*
     private func modifiedTccDB() {
     var mapScreenCaptureAppList: [String: Int]?
     
     systemManager.getScreenCaptureAppList(&mapScreenCaptureAppList!)
     
     for mapItem in mapScreenCaptureAppList {
     switch mapItem[1] {
     case JDEScreenCaptureResult.Denied:
     setLog("Denied [\(mapItem.first[0])]")
     break
     case JDEScreenCaptureResult.Unknown:
     setLog("Unknown [\(mapItem.first[0])]")
     break
     case JDEScreenCaptureResult.Allowed:
     setLog("Allowed [\(mapItem.first[0])]")
     break
     case JDEScreenCaptureResult.Limited:
     setLog("Limited [\(mapItem.first[0])]")
     break
     case JDEScreenCaptureResult.Delete:
     setLog("Delete [\(mapItem.first[0])]")
     break
     default:
     break
     }
     
     if mapItem.first[0] == "/" {
     let nPid = processUtilManager.getProcessPID(for: mapItem.first)
     setLog("Path : [\(mapItem.first)], Pid : [\(nPid)]")
     continue
     }
     
     let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: NSString(utf8String: mapItem.first) as! String)
     print("path=[\(url.path)]")
     
     let vAllPidList: [pid_t] = []
     processUtilManager.getAllPidList(vAllPidList)
     for nPid in vAllPidList {
     let bundleIdentifier = NSRunningApplication(processIdentifier: nPid)?.bundleIdentifier
     if bundleIdentifier != nil {
     let screenCaptureApp = NSString(utf8String: mapItem.first)
     if bundleIdentifier?.compare(screenCaptureApp, options: .caseInsensitive) == .orderedSame {
     print("Bundle Identifier : [\(bundleIdentifier)], Pid : [\(nPid)]")
     }
     }
     }
     }
     }
     */
    
}
