//
//  SystemSecurityAndPrivacyUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/22.
//

import Foundation
import SQLite3

enum JDEScreenCaptureResult : Int {
    case Denied = 0      // 차단
    case Unknown     // 알수 없음
    case Allowed     // 허용
    case Limited     // 제한된 접근
    case Delete      // 항목 삭제
}

class SystemSecurityAndPrivacyUtil: NSObject {
    static let shared = SystemSecurityAndPrivacyUtil()
    private override init() {}
    
    let TCC_DB_PATH                = "/Library/Application Support/com.apple.TCC/TCC.db"
    let TCC_DB_QUERY               = "select * from access"
    let TCC_SERVICE_SCREEN_CAPTURE = "kTCCServiceScreenCapture"
    
    var m_mapScreenCaptureAppList: [String: Int] = [:]
    var m_mutexScreenCaptrueAppList = pthread_mutex_t()
    
    func getScreenCaptureAppList(_ mapScreenCaptureAppList: inout [String: Int]) -> Bool {
        mapScreenCaptureAppList.removeAll()
        
        var mapScreenCaptureAppListTemp: [Int] = []
        
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
                        
                        mapScreenCaptureAppListTemp.append(Int(nAllow))
                    }
                }
                bRetValue = true
                sqlite3_finalize(pTccDBStatement)
            }
            sqlite3_close(pTccDB)
            pTccDB = nil
        } else {
            sqlite3_close(pTccDB)
            pTccDB = nil
        }
        
        pthread_mutex_lock(&m_mutexScreenCaptrueAppList)
        /*
        if MemoryLayout.size(ofValue: m_mapScreenCaptureAppList) <= MemoryLayout.size(ofValue: mapScreenCaptureAppListTemp) {
            for mapItem in mapScreenCaptureAppListTemp {
                if m_mapScreenCaptureAppList[m_mapScreenCaptureAppList.endIndex] == m_mapScreenCaptureAppList
            }
        } else {
            
        }
         */
        
        pthread_mutex_unlock(&m_mutexScreenCaptrueAppList)
        
        return bRetValue
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
