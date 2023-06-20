//
//  OpenFileManager.swift
//  PFEndPointSecurityAppTemp
//
//  Created by jiran_daniel on 2023/06/11.
//

import Foundation
import System
import os

struct FILE_ITEM {
    var strProcessCWD: String
    var strFilePath: String
    var stStat: stat
    var bIsUsed: Bool
}

typealias OPEN_FILE_MAP = [pid_t: FILE_ITEM_MAP]
typealias FILE_ITEM_MAP = [String: [FILE_ITEM]]

class OpenFileManager: NSObject {
    static let instance = OpenFileManager()
    var instance: OpenFileManager?
    var m_mutexOpenFile = pthread_mutex_t()
    var m_mapOpenFile = OPEN_FILE_MAP()
    
    private let SPACE_AND_COPY_TEXT = " copy"
    
    private override init() {
        pthread_mutex_init(&m_mutexOpenFile, nil)
    }
    
    deinit {
        pthread_mutex_destroy(&m_mutexOpenFile)
    }
    
    func addOpenFileItem(_ nPid: pid_t, _ pszProcPath: String, _ stFileItem: FILE_ITEM) {
        var OK: ObjCBool = true
        if FileManager.default.fileExists(atPath: String(stFileItem.stStat.st_mode), isDirectory: &OK) { return }
        
        checkAndDelOpenFileMap(stFileItem.strFilePath)
        
        pthread_mutex_lock(&m_mutexOpenFile)
        
        var bFindFileItem = false
        guard var fileItem = m_mapOpenFile[nPid] else { return }
        fileItem[pszProcPath]!.forEach { data in
            if data.strFilePath == stFileItem.strFilePath {
                bFindFileItem = true
                return
            }
        }
        
        if bFindFileItem == false {
            fileItem[pszProcPath]!.append(stFileItem)
        }
        
        pthread_mutex_unlock(&m_mutexOpenFile)
    }
    
    func setUsedOpenFileItem(_ nPid: pid_t, _ pszProcPath: String, _ strFilePath: String) {
        guard var fileItem = m_mapOpenFile[nPid] else { return }
        guard let fileItemArr = fileItem[pszProcPath] else { return }
        
        for (index, data) in fileItemArr.enumerated() {
            if data.strFilePath == strFilePath {
                var stFileItem = FILE_ITEM(strProcessCWD: data.strProcessCWD, strFilePath: data.strFilePath, stStat: data.stStat, bIsUsed: true)
                
                fileItem[pszProcPath]?.remove(at: index)
                fileItem[pszProcPath]?.append(stFileItem)
                
                return
            }
        }
    }
    
    func checkAndDelOpenFileMap(_ strFilePath: String) {
        let processManager = ProcessUtil.shared
        var vAllPids: [pid_t] = []
        processManager.getAllPidList(&vAllPids)
        
        pthread_mutex_lock(&m_mutexOpenFile)
        
        for item in m_mapOpenFile {
            var bIsExistProc = false
            
            for nPid in vAllPids {
                if !m_mapOpenFile[pid_t(nPid)]!.isEmpty {
                    let path = processManager.getProcessPath(for: nPid)
                    if m_mapOpenFile[pid_t(nPid)]!.count > 0 {
                        bIsExistProc = true
                        break
                    }
                }
            }
            
            if bIsExistProc == false {
                m_mapOpenFile.removeValue(forKey: item.key)
                continue
            }
        }
        
        pthread_mutex_unlock(&m_mutexOpenFile)
    }
    
    func getOpenFileItemWithFileItem(_ nPid: pid_t, _ strProcPath: String, _ vFileItem: inout [FILE_ITEM]) {
        guard var fileItem = m_mapOpenFile[nPid] else { return }
        guard let fileItemArr = fileItem[strProcPath] else { return }
        
        vFileItem.removeAll()
        vFileItem = fileItemArr
    }
    
    func getOpenFilePathFromName(_ vFileItem: [FILE_ITEM], _ strDstFileName: String) -> String {
        let pathManager = PathUtil.shared
        
        var strSrcFilePath = ""
        var strDstFilePath = strDstFileName
        
        var nPos = String.Index(utf16Offset: NSNotFound, in: strDstFilePath)
        var strTempDstFilePath: String
        
        while nPos == String.Index(utf16Offset: NSNotFound, in: strDstFilePath) {
            for itFileItem in vFileItem.reversed() {
                if let range = itFileItem.strFilePath.range(of: strDstFilePath) {
                    if itFileItem.bIsUsed {
                        return ""
                    }
                    
                    strSrcFilePath = String(itFileItem.strFilePath)
                    return String(itFileItem.strFilePath)
                }
            }
            
            strTempDstFilePath = strDstFilePath
            strDstFilePath = pathManager.delRootDirectory(strTempDstFilePath)
            
            if strDstFilePath.compare(strTempDstFilePath) == .orderedSame {
                break
            }
        }
        
        return strSrcFilePath
    }
    
    func getOpenFilePathFromRemoveSpaceAfterName(_ vFileItem: [FILE_ITEM], _ strDstFileName: inout String) -> String {
        let pathManager = PathUtil.shared
        var strSrcFilePath = ""
        
        if let nPos = strDstFileName.range(of: " ", options: .backwards) {
            var strDstFileName = String(strDstFileName[..<nPos.lowerBound])
            for itFileItem in vFileItem.reversed() {
                let strFileName = pathManager.getFileName(itFileItem.strFilePath, false)
                if strFileName == strDstFileName {
                    if itFileItem.bIsUsed {
                        return ""
                    }
                    strSrcFilePath = itFileItem.strFilePath
                    strDstFileName = strFileName
                    break
                }
            }
        }
        
        return strSrcFilePath
    }
    
    func getOpenFilePathFromRemoveAllCopyStringAfterName(_ vFileItem: [FILE_ITEM], _ strDstFileName: inout String) -> String {
        let pathManager = PathUtil.shared
        
        var strSrcFilePath = ""
        if let nPos = strDstFileName.range(of: SPACE_AND_COPY_TEXT, options: .backwards) {
            var strDstFileName = String(strDstFileName[..<nPos.lowerBound])
            for itFileItem in vFileItem.reversed() {
                var strFileName = pathManager.getFileName(itFileItem.strFilePath, false)
                if let nPos = strFileName.range(of: SPACE_AND_COPY_TEXT, options: .backwards) {
                    strFileName = String(strFileName[..<nPos.lowerBound])
                }
                
                if strFileName == strDstFileName {
                    if itFileItem.bIsUsed {
                        return ""
                    }
                    strSrcFilePath = itFileItem.strFilePath
                    strDstFileName = strFileName
                    break
                }
            }
        }
        
        return strSrcFilePath
    }
    
    func getOpenFilePathFromRemoveCopyStringAfterName(_ vFileItem: [FILE_ITEM], _ strDstFileName: inout String) -> String {
        let pathManager = PathUtil.shared
        var strSrcFilePath = ""
        
        if let nPos = strDstFileName.range(of: SPACE_AND_COPY_TEXT, options: .backwards) {
            strDstFileName = String(strDstFileName[..<nPos.lowerBound])
            for fileItem in vFileItem.reversed() {
                let strFileName = pathManager.getFileName(fileItem.strFilePath, false)
                if strFileName == strDstFileName {
                    if fileItem.bIsUsed {
                        return ""
                    }
                    
                    strSrcFilePath = fileItem.strFilePath
                    break
                }
            }
        }
        
        return strSrcFilePath
    }
    
    func getOpenFilePath(_ nPid: pid_t, _ strProcPath: String, _ strDstFilePath: String) -> String {
        let pathManager = PathUtil.shared
        if !isExternalStorageCheckProcess(strProcPath) {
            return ""
        }
        
        pthread_mutex_lock(&m_mutexOpenFile)
        
        var vFileItem = [FILE_ITEM]()
        getOpenFileItemWithFileItem(nPid, strProcPath, &vFileItem)
        
        var strDstPath = pathManager.delRootDirectory(strDstFilePath)
        strDstPath = pathManager.delRootDirectory(strDstPath)
        var strSrcFilePath = getOpenFilePathFromName(vFileItem, strDstPath)
        
        if strSrcFilePath.isEmpty {
            var strDstFileName = pathManager.getFileName(strDstFilePath)
            strSrcFilePath = getOpenFilePathFromRemoveSpaceAfterName(vFileItem, &strDstFileName)
            
            if strSrcFilePath.isEmpty {
                strSrcFilePath = getOpenFilePathFromRemoveCopyStringAfterName(vFileItem, &strDstFileName)
            }
            
            if strSrcFilePath.isEmpty {
                strSrcFilePath = getOpenFilePathFromRemoveAllCopyStringAfterName(vFileItem, &strDstFileName)
            }
        }
        
        if !strSrcFilePath.isEmpty {
            setUsedOpenFileItem(nPid, strProcPath, strSrcFilePath)
        }
        
        pthread_mutex_unlock(&m_mutexOpenFile)
        
        return strSrcFilePath
    }
    
    func printOpenFileItem() -> Bool {
        let connectionManager = XPCManager.shared
        
        pthread_mutex_lock(&m_mutexOpenFile)
        defer { pthread_mutex_unlock(&m_mutexOpenFile) }
        
        for (pid, fileItemMap) in m_mapOpenFile {
            for (procPath, fileItems) in fileItemMap {
                for fileItem in fileItems {
                    var dictOpenFileItemData = NSMutableDictionary()
                    dictOpenFileItemData.setObject(AuthNameSpace.EVENT_TYPE_PRINT_OPEN_FILE_ITEM, forKey: AuthNameSpace.KEY_EVENT_TYPE_AUTH as NSCopying)
                    dictOpenFileItemData.setObject(fileItem.strFilePath, forKey: EndPointNameSpace.KEY_SRC_PATH as NSCopying)
                    dictOpenFileItemData.setObject(fileItem.stStat, forKey: EndPointNameSpace.KEY_STAT as NSCopying)
                    dictOpenFileItemData.setObject(NSNumber(value: pid), forKey: EndPointNameSpace.KEY_PID as NSCopying)
                    dictOpenFileItemData.setObject(procPath, forKey: EndPointNameSpace.KEY_PROC_PATH as NSCopying)
                    
                    let appIDList = connectionManager.getAllAppID()
                    if appIDList == nil || appIDList!.count == 0 {
                        return true
                    }
                    
                    for appID in appIDList! {
                        let _ = connectionManager.sendDataWithDictionaryWithAppIDWithResponseHandler(dictOpenFileItemData, appID: appID as! NSString) { success in
                            // Response handler
                        }
                    }
                }
            }
        }
        pthread_mutex_unlock(&m_mutexOpenFile);
        
        return true
    }
    
    private func isExternalStorageCheckProcess(_ strProcPath: String) -> Bool {
        if strProcPath == EndPointNameSpace.DESKTOP_SERVICES_HELPER_PROC_PATH ||
            strProcPath == EndPointNameSpace.CP_PROC_PATH ||
            strProcPath == EndPointNameSpace.MV_PROC_PATH {
            return true
        }
        return false
    }
}
