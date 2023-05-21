//
//  ProtectionViewController.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/05/18.
//

import Cocoa

enum ProtectionNameSpace {
    static let PCFILTER_APP_DIRECTORY             = "/Applications/PCFILTER.app"
    static let PCFILTER_UNINSTALL_APP_DIRECTORY   = "/Applications/PCFILTER UNINSTALL.app"
    
    static let TEST_FILE_PATH                     = "/Applications/PCFILTER UNINSTALL.app/Contents/Test/test.txt"
    
    static let PCFILTER_APPS: [PFSAppInfo]        = [
                                                        PFSAppInfo("pflogd", "/Applications/PCFILTER.app/Contents/Resources/bin/pflogd",                                       "/Library/LaunchAgents/com.jiran.pflogd.plist"),
                                                        PFSAppInfo("pfchkpatd", "/Applications/PCFILTER.app/Contents/Resources/bin/pfchkpatd", "/Library/LaunchAgents/com.jiran.pfchkpatd.plist"),
                                                        PFSAppInfo("pfmaind", "/Applications/PCFILTER.app/Contents/Resources/bin/pfmaind", "/Library/LaunchAgents/com.jiran.pfmaind.plist"),
                                                        PFSAppInfo("pfprotd", "/Applications/PCFILTER.app/Contents/Resources/bin/pfprotd", "/Library/LaunchAgents/com.jiran.pfprotd.plist"),
                                                        PFSAppInfo("pfscand", "/Applications/PCFILTER.app/Contents/Resources/bin/pfscand", "/Library/LaunchAgents/com.jiran.pfscand.plist"),
                                                        PFSAppInfo("com.jiran.PFEndPointSecurityApp",
                                                            "/Volumes/Develop/jiran/04_14/Develop/PFEndPointProtectionApp//Build/Release/PFEndPointSecurityApp.app/Contents/MacOS/PFEndPointSecurityApp",
                                                            "/Library/LaunchAgents/com.jiran.pfscand.plist")
                                                    ]
}

class ProtectionViewController: NSViewController {
    @IBOutlet var textView: NSTextView!
    
    private var textViewLineCount = 0
    
    let fileNotiManager = FileNotificationXPCAppCommunication.shared
    let protectionManager = ProtectionUtil.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(self, selector: #selector(powerOffNotification), name: NSWorkspace.willPowerOffNotification, object: nil)
    }
    
    @objc private func powerOffNotification(_ notification: NotificationCenter) {
        clearProtectionPath(self)
        clearProtectionFilePath(self)
        clearProtectionProcPath(self)
        clearProtectionProcSignedld(self)
        
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func addAcceptProcPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<ProtectionNameSpace.PCFILTER_APPS.count {
            
            dictSendData.setObject(PolicyKinds.ProtectionAcceptProcessSignedId.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(ProtectionNameSpace.PCFILTER_APPS[i].procPath!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if fileNotiManager.sendClientData(dictSendData) == false {
                setLog("Add Accept Process Path \(String(describing: ProtectionNameSpace.PCFILTER_APPS[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Accept Process Path")
    }
    
    @IBAction func addAcceptProcSignedld(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<ProtectionNameSpace.PCFILTER_APPS.count {
            
            dictSendData.setObject(PolicyKinds.ProtectionAcceptProcessSignedId.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(ProtectionNameSpace.PCFILTER_APPS[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if fileNotiManager.sendClientData(dictSendData) == false {
                setLog("Add Accept Process SignedId \(String(describing: ProtectionNameSpace.PCFILTER_APPS[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Accept Process SignedId")
    }
    
    @IBAction func addProtectionPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.ProtectionPath.rawValue), forKey: KEY_ADD_POLICY as NSCopying)
        dictSendData.setObject(ProtectionNameSpace.PCFILTER_APP_DIRECTORY, forKey: KEY_POLICY_ITEM as NSCopying)
        
        if fileNotiManager.sendClientData(dictSendData) == false {
            setLog("Add Protection Path \(ProtectionNameSpace.PCFILTER_UNINSTALL_APP_DIRECTORY) Failed !!!")
            return
        }
        
        setLog("Add Protection Path \(ProtectionNameSpace.PCFILTER_UNINSTALL_APP_DIRECTORY)")
        
        dictSendData.setObject(PolicyKinds.ProtectionPath.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        dictSendData.setObject(ProtectionNameSpace.PCFILTER_APP_DIRECTORY, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
        
        if fileNotiManager.sendClientData(dictSendData) == false {
            setLog("Add Protection Path \(ProtectionNameSpace.PCFILTER_APP_DIRECTORY) Failed !!!")
            return
        }
        
        setLog("Add Protection Path \(ProtectionNameSpace.PCFILTER_APP_DIRECTORY)")
    }
    
    @IBAction func addProtectionFilePath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<ProtectionNameSpace.PCFILTER_APPS.count {
            
            dictSendData.setObject(PolicyKinds.ProtectionFilePath.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(ProtectionNameSpace.PCFILTER_APPS[i].plistPath!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if fileNotiManager.sendClientData(dictSendData) == false {
                setLog("Add Protection File Path \(String(describing: ProtectionNameSpace.PCFILTER_APPS[i].plistPath)) Failed !!!")
                return
            }
        }
        
        setLog("Add Protection File Path")
    }
    
    @IBAction func addProtectionProcPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<ProtectionNameSpace.PCFILTER_APPS.count {
            
            dictSendData.setObject(PolicyKinds.ProtectionProcessPath.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(ProtectionNameSpace.PCFILTER_APPS[i].procPath!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if fileNotiManager.sendClientData(dictSendData) == false {
                setLog("Add Protection Process Path \(String(describing: ProtectionNameSpace.PCFILTER_APPS[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Protection Process Path")
    }
    
    @IBAction func addProtectionProcSignedld(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        
        for i in 0..<ProtectionNameSpace.PCFILTER_APPS.count {
            
            dictSendData.setObject(PolicyKinds.ProtectionProcessSignedId.rawValue, forKey: EndPointNameSpace.KEY_ADD_POLICY as NSCopying)
            dictSendData.setObject(ProtectionNameSpace.PCFILTER_APPS[i].signedID!, forKey: EndPointNameSpace.KEY_POLICY_ITEM as NSCopying)
            
            if fileNotiManager.sendClientData(dictSendData) == false {
                setLog("Add Protection Process SignedId \(String(describing: ProtectionNameSpace.PCFILTER_APPS[i].signedID)) Failed !!!")
                return
            }
        }
        
        setLog("Add Protection Process SignedId")
    }
    
    @IBAction func clearProtectionPath(_ sender: Any) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.ProtectionPath.rawValue, forKey: EndPointNameSpace.KEY_CLEAR_POLICY as NSCopying)
        
        if fileNotiManager.sendClientData(dictSendData) == false {
            setLog("Clear Protection Path Failed !!!")
            return
        }
        
        setLog("Clear Protection Path")
    }
    
    @IBAction func clearProtectionFilePath(_ sender: Any) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.ProtectionFilePath.rawValue, forKey: EndPointNameSpace.KEY_CLEAR_POLICY as NSCopying)
        
        if fileNotiManager.sendClientData(dictSendData) == false {
            setLog("Clear Protection File Path Failed !!!")
            return
        }
        
        setLog("Clear Protection File Path")
    }
    
    @IBAction func clearProtectionProcPath(_ sender: Any) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.ProtectionProcessPath.rawValue, forKey: EndPointNameSpace.KEY_CLEAR_POLICY as NSCopying)
        
        if fileNotiManager.sendClientData(dictSendData) == false {
            setLog("Clear Protection Process Path Failed !!!")
            return
        }
        
        setLog("Clear Protection Process Path")
    }
    
    @IBAction func clearProtectionProcSignedld(_ sender: Any) {
        let dictSendData = NSMutableDictionary()
        
        dictSendData.setObject(PolicyKinds.ProtectionProcessSignedId.rawValue, forKey: EndPointNameSpace.KEY_CLEAR_POLICY as NSCopying)
        
        if fileNotiManager.sendClientData(dictSendData) == false {
            setLog("Clear Protection Process SignedId Failed !!!")
            return
        }
        
        setLog("Clear Protection Process SignedId")
    }
    
    @IBAction func fileTruncate(_ sender: NSButton) {
        if truncate(ProtectionNameSpace.TEST_FILE_PATH, getFileSize(ProtectionNameSpace.TEST_FILE_PATH) + 1) != 0 {
            setLog("File Truncate Failed !!!")
            return
        }
        
        setLog("File Truncate Success")
    }
    
    @IBAction func setAttrList(_ sender: NSButton) {
        let stAttrBuf = UnsafeMutableRawPointer.allocate(byteCount: 32, alignment: 4)
        
        var stAttrList: attrlist?
        stAttrList?.bitmapcount = u_short(ATTR_BIT_MAP_COUNT)
        stAttrList?.commonattr = attrgroup_t(ATTR_CMN_FNDRINFO)
        
        if setattrlist(ProtectionNameSpace.TEST_FILE_PATH, &stAttrList, stAttrBuf, 32, 0) != 0 {
            setLog("File SetAttrList Failed !!!")
        }
        setLog("File SetAttrList Success")
    }
    
    @IBAction func document(_ sender: NSButton) {
        let log = "-------------------------------------------------- Signal Number -----------------------------------------------------\n"
        + "Name         Number     Action          Description\n"
        + "----------------------------------------------------------------------------------------------------------------------\n"
        + "SIGHUP       1          종료             hangup\n"
        + "SIGINT       2          종료             interrupt\n"
        + "SIGQUIT      3          종료(코어 덤프)    quit\n"
        + "SIGILL       4          종료(코어 덤프)    illegal instruction (not reset when caught)\n"
        + "SIGTRAP      5          종료(코어 덤프)    trace trap (not reset when caught)\n"
        + "SIGABRT      6          종료(코어 덤프)    abort \n"
        + "SIGIOT       SIGABRT    종료             compatibility\n"
        + "SIGEMT       7          종료             EMT instruction\n"
        + "SIGFPE       8          종료(코어 덤프)    floating point exception\n"
        + "SIGKILL      9          종료             kill (cannot be caught or ignored)\n"
        + "SIGBUS      10          종료(코어 덤프)    bus error\n"
        + "SIGSEGV     11          종료(코어 덤프)    segmentation violation\n"
        + "SIGSYS      12          종료(코어 덤프)    bad argument to system call\n"
        + "SIGPIPE     13          종료             write on a pipe with no one to read it\n"
        + "SIGALRM     14          종료             alarm clock\n"
        + "SIGTERM     15          종료             software termination signal from kill\n"
        + "SIGURG      16          무시             urgent condition on IO channel\n"
        + "SIGSTOP     17          정지             sendable stop signal not from tty\n"
        + "SIGTSTP     18          정지             stop signal from tty\n"
        + "SIGCONT     19          계속             continue a stopped process\n"
        + "SIGCHLD     20          무시             to parent on child stop or exit\n"
        + "SIGTTIN     21          정지             to readers pgrp upon background tty read\n"
        + "SIGTTOU     22          정지             like TTIN for output if (tp->t_local&LTOSTOP)\n"
        + "SIGIO       23          무시             input/output possible signal\n"
        + "SIGXCPU     24          종료(코어 덤프)    exceeded CPU time limit\n"
        + "SIGXFSZ     25          종료(코어 덤프)    exceeded file size limit\n"
        + "SIGVTALRM   26          종료             virtual time alarm\n"
        + "SIGPROF     27          종료             profiling time alarm\n"
        + "SIGWINCH    28          무시             window size changes\n"
        + "SIGINFO     29          무시             information request\n"
        + "SIGUSR1     30          종료             user defined signal 1\n"
        + "SIGUSR2     31          종료             user defined signal 2\n"
        + "----------------------------------------------------------------------------------------------------------------------\n"
        
        setLog(log)
    }
    
    private func setLog(_ text: String) {
        textViewLineCount = setTextViewText(self.textView, text, textViewLineCount)
        self.textView.scrollToEndOfDocument(self)
    }
    
    private func getFileSize(_ filePath: String) -> Int64 {
        var fileSize: UInt64?
        
        do {
            //return [FileAttributeKey : Any]
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
//            fileSize = attr[FileAttributeKey.size] as! UInt64

            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            
            return Int64(fileSize!)
        } catch {
            print("Error: \(error)")
        }
        
        return Int64()
    }
}
