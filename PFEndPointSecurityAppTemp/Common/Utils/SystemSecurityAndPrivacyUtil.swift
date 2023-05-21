//
//  SystemSecurityAndPrivacyUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/22.
//

import Foundation
import SQLite3

class SystemSecurityAndPrivacyUtil: NSObject {
    static let shared = SystemSecurityAndPrivacyUtil()
    private override init() {}
    
    let TCC_DB_PATH                = "/Library/Application Support/com.apple.TCC/TCC.db"
    let TCC_DB_QUERY               = "select * from access"
    let TCC_SERVICE_SCREEN_CAPTURE = "kTCCServiceScreenCapture"
    
    func getScreenCaptureAppList(_ mapScreenCaptureAppList: inout [String: Int]) -> Bool {
        mapScreenCaptureAppList.removeAll()
        
        let mapScreenCaptureAppListTemp: [String: Int]?
        
        var pTccDB: OpaquePointer?
        var pTccDBStatement: OpaquePointer?
        var bRetValue = false
        
        if sqlite3_open(TCC_DB_PATH, &pTccDB) == SQLITE_OK {
            if sqlite3_prepare_v2(pTccDB, TCC_DB_QUERY, -1, &pTccDBStatement, nil) == SQLITE_OK {
                while sqlite3_step(pTccDBStatement) == SQLITE_ROW {
                    let strServiceKind = sqlite3_column_text(pTccDBStatement, 0)
                    guard let strServiceKindStr = String.fromCString(cs: strServiceKind!, length: sizeof(strServiceKind)) else { return false }
                    
                    if strServiceKindStr == TCC_SERVICE_SCREEN_CAPTURE {
                        let strBundleID = sqlite3_column_text(pTccDBStatement, 1)
                        let nAllow = sqlite3_column_int(pTccDBStatement, 3)
                        
                        mapScreenCaptureAppListTemp[strBundleID] = [nAllow]
                    }
                }
            }
        }
    }
}

extension String {
    static func fromCString(cs: UnsafePointer<UInt8>, length: Int!) -> String? {
        if length == nil { // no length given, use \0 standard variant
            return String(cString: cs)
        }
        
        let buflen = length + 1
        let buf    = UnsafeMutablePointer<UInt8>.allocate(capacity: buflen)
        memcpy(buf, cs, length)
        buf[length] = 0 // zero terminate
        let s = String(cString: buf)
        buf.deallocate()
        return s
    }
}
