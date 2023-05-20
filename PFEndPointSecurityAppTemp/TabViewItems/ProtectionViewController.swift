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

    static let TEST_FILE_PATH: [String]           = ["/Applications/PCFILTER UNINSTALL.app/Contents/Test/test.txt"]

    static let PFS_APP_INFO: [[String]]           = [["pflogd",
                                                    "/Applications/PCFILTER.app/Contents/Resources/bin/pflogd",
                                                    "/Library/LaunchAgents/com.jiran.pflogd.plist"],
                                                   ["pfchkpatd",
                                                    "/Applications/PCFILTER.app/Contents/Resources/bin/pfchkpatd",
                                                    "/Library/LaunchAgents/com.jiran.pfchkpatd.plist"],
                                                   ["pfmaind",
                                                    "/Applications/PCFILTER.app/Contents/Resources/bin/pfmaind",
                                                    "/Library/LaunchAgents/com.jiran.pfmaind.plist"],
                                                   ["pfprotd",
                                                    "/Applications/PCFILTER.app/Contents/Resources/bin/pfprotd",
                                                    "/Library/LaunchAgents/com.jiran.pfprotd.plist"],
                                                   ["pfscand",
                                                    "/Applications/PCFILTER.app/Contents/Resources/bin/pfscand",
                                                    "/Library/LaunchAgents/com.jiran.pfscand.plist"],
                                                   ["com.jiran.PFEndPointSecurityApp",
                                                    "/Volumes/Develop/jiran/04_14/Develop/PFEndPointProtectionApp//Build/Release/PFEndPointSecurityApp.app/Contents/MacOS/PFEndPointSecurityApp",
                                                    "/Library/LaunchAgents/com.jiran.pfscand.plist" ] ]
}

class ProtectionViewController: NSViewController {
    let protectionManager = ProtectionUtil.shared
    private var textViewLineCount = 0
    
    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addAcceptProcPath(_ sender: NSButton) {
        let dictSendData = NSMutableDictionary()
        dictSendData.setObject(NSNumber(integerLiteral: PolicyKinds.ProtectionPath.rawValue), forKey: KEY_ADD_POLICY as NSCopying)
        dictSendData.setObject(ProtectionNameSpace.PCFILTER_APP_DIRECTORY, forKey: KEY_POLICY_ITEM as NSCopying)
        
        print(dictSendData)
    }
    
    @IBAction func addAcceptProcSignedld(_ sender: NSButton) {
        
    }
    
    @IBAction func addProtectionPath(_ sender: NSButton) {
        
    }
    
    @IBAction func addProtectionFilePath(_ sender: NSButton) {
        
    }
    
    @IBAction func addProtectionProcPath(_ sender: NSButton) {
        
    }
    
    @IBAction func addProtectionProcSignedld(_ sender: NSButton) {
        
    }
    
    @IBAction func clearProtectionPath(_ sender: NSButton) {
        
    }
    
    @IBAction func clearProtectionFilePath(_ sender: NSButton) {
        
    }
    
    @IBAction func clearProtectionProcPath(_ sender: NSButton) {
        
    }
    
    @IBAction func clearProtectionProcSignedld(_ sender: NSButton) {
        
    }
    
    @IBAction func fileTruncate(_ sender: NSButton) {
        
    }
    
    @IBAction func setAttrList(_ sender: NSButton) {
        
    }
    
    
    
}
