//
//  PathUtil.swift
//  PFEndPointSecurityAppTemp
//
//  Created by AlexHwang on 2023/05/21.
//

import Foundation

class PathUtil: NSObject {
    static let shared = PathUtil()
    private override init() {}
    
    func getFileName(_ strPath: String, _ bExt: Bool? = true) -> String {
        if strPath.isEmpty {
            return ""
        }
        
        var strFileName = ""
        
        if !strPath.contains("/") {
            strFileName = strPath
        } else {
            let index = strPath.firstIndex(of: "/")
            strFileName = String(strPath[index!...])
        }
        
        if bExt == false && strFileName.isEmpty == false {
            if strFileName.contains(".") {
                let index = strPath.firstIndex(of: ".")
                strFileName = String(strFileName[...index!])
            }
        }
        
        return strFileName
    }
    
    func delRootDirectory(_ strPath: String) -> String {
        if strPath.isEmpty {
            return ""
        }
        
        var path = ""
        if let index = strPath.firstIndex(of: "/") {
            let startIndex = strPath.index(after: index)
            path = String(strPath[startIndex...])
        } else {
            path = strPath
        }
        
        return path
    }
}
