//
//  PFDefine.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/20.
//

import Foundation

struct PFSAppInfoFlags {
    let signedID: NSString?
    let procPath: NSString?
    let nFileFlag: Int?
    let bIsFileReadDeny: Bool?
    
    init(_ signedID: NSString, _ procPath: NSString, _ nFileFlag: Int, _ bIsFileReadDeny: Bool) {
        self.signedID = signedID
        self.procPath = procPath
        self.nFileFlag = nFileFlag
        self.bIsFileReadDeny = bIsFileReadDeny
    }
}

struct PFSAppInfoShort {
    let signedID: NSString?
    let procPath: NSString?
    
    init(_ signedID: NSString, _ procPath: NSString) {
        self.signedID = signedID
        self.procPath = procPath
    }
}

struct PFSAppInfo {
    let signedID: NSString?
    let procPath: NSString?
    let plistPath: NSString?
    
    init(_ signedID: NSString, _ procPath: NSString, _ plistPath: NSString) {
        self.signedID = signedID
        self.procPath = procPath
        self.plistPath = plistPath
    }
}

let EXCEPTION_PATH_LIST: [String]      = [ "/usr/bin/",
                                           "/usr/lib/",
                                           "/usr/libexec/",
                                           "/usr/sbin/",
                                           "/usr/share/",
                                           "/usr/standalone/",
                                           "/bin/",
                                           "/sbin/",
                                           "/dev/",
                                           "/System/Applications/",
                                           "/System/Developer/",
                                           "/System/DriverKit/",
                                           "/System/Library/",
                                           "/System/iOSSupport/",
                                           "/System/Volumes/BaseSystem/",
                                           "/System/Volumes/FieldService/",
                                           "/System/Volumes/FieldServiceDiagnostic/",
                                           "/System/Volumes/FieldServiceRepair/",
                                           "/System/Volumes/Hardware/",
                                           "/System/Volumes/Preboot/",
                                           "/System/Volumes/Recovery/",
                                           "/System/Volumes/Update/",
                                           "/System/Volumes/VM/",
                                           "/System/Volumes/iSCPreboot/" ]

let TCC_DB_PATH              = "/Library/Application Support/com.apple.TCC/TCC.db-journal"
let TCC_DB_PATH_             = "/Library/Application Support/com.apple.TCC/TCC.db"
